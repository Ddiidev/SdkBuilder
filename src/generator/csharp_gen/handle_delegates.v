module csharp_gen

import entities

const types_relation = {
	'f32': 'float'
}

fn resolver_name_type(name_type string, name_module string) string {
	return if name_type.contains('${name_module}.') {
		typ := name_type[name_module.len + 1..]
		if typ in csharp_gen.types_relation {
			csharp_gen.types_relation[typ]
		} else {
			typ
		}
	} else {
		typ := name_type
		if typ in csharp_gen.types_relation {
			csharp_gen.types_relation[typ]
		} else {
			typ
		}
	}
}

fn (mut ex_ast ExtensionAst) handle_delegates() {
	base_module := if ex_ast.ast.stmts.first().ast_type == 'Module' {
		ex_ast.ast.stmts.first().name
	} else {
		''
	}

	for node_delegate in ex_ast.ast.stmts.filter(it.ast_type == 'FnDecl') {
		name_fn, pure_name_fn := if node_delegate.name.contains('${base_module}.') {
			pure_name := node_delegate.name[base_module.len + 1..]
			resolver_names(pure_name), pure_name
		} else {
			resolver_names(node_delegate.name), node_delegate.name
		}
		type_fn := resolver_name_type(node_delegate.return_type, base_module)
		type_delegate := if type_fn == 'string' {
			'VStringInterop'
		} else if type_fn in ex_ast.structs {
			'${type_fn}Interop'
		} else {
			type_fn
		}
		name_delegate := '${name_fn}Delegate'

		mut code_struct := $tmpl('sdk_files/ImplDelegates.cs')

		line_param := node_delegate.params.map(fn [base_module] (it entities.Params) string {
			return it.name + ' ' + resolver_name_type(it.typ, base_module)
		}).join(', ')

		value_return_fn := match type_fn {
			'string' {
				'new VString(_${name_fn}($line_param))'
			}
			'int' {
				'_${name_fn}($line_param)'
			}
			'float' {
				'_${name_fn}($line_param)'
			}
			else {
				'_${name_fn}($line_param)'
			}
		}
		code_struct += $tmpl('sdk_files/ImplPropertyFromDelegates.cs').replace('\n\n',
			'\n')

		ex_ast.delegates[name_delegate] = Delegate{
			name_function_dl: pure_name_fn
			name_var_function: '_${name_fn}'
			content: code_struct
		}
	}
}

fn resolver_names(name string) string {
	words := name.split('_')
	mut transformed := ''
	for word in words {
		capitalized := word[0].ascii_str().to_upper() + word[1..]
		transformed += capitalized
	}
	return transformed
}
