module csharp_gen

import entities
import leafscale.veemarker

const types_relation = {
	'f32': 'float'
	'f64': 'double'
}

fn resolver_name_type(name_type string, name_module string) string {
	typ_ := if name_type.contains('${name_module}.') {
		typ := name_type[name_module.len + 1..]
		if typ in csharp_gen.types_relation {
			csharp_gen.types_relation[typ]
		} else {
			typ
		}
	} else {
		if name_type in csharp_gen.types_relation {
			csharp_gen.types_relation[name_type]
		} else {
			name_type
		}
	}

	return match typ_ {
		'string' {
			'VString'
		}
		else {
			typ_
		}
	}
}

fn (mut ext ExtensionAst) handle_delegates(mut engine veemarker.Engine) {
	println('\n -- Implementing delegates -- ')
	base_module := if ext.ast.stmts.first().ast_type == 'Module' {
		ext.ast.stmts.first().name
	} else {
		''
	}

	for node_delegate in ext.ast.stmts.filter(it.ast_type == 'FnDecl') {
		name_fn, pure_name_fn := if node_delegate.name.contains('${base_module}.') {
			pure_name := node_delegate.name[base_module.len + 1..]
			resolver_names(pure_name), pure_name
		} else {
			resolver_names(node_delegate.name), node_delegate.name
		}
		type_fn := resolver_name_type(node_delegate.return_type, base_module)
		type_delegate := if type_fn == 'VString' {
			'VStringInterop'
		} else if type_fn in ext.structs {
			'${type_fn}Interop'
		} else {
			type_fn
		}
		name_delegate := '${name_fn}Delegate'

		parameter_resolveds := node_delegate.params.map(fn [base_module] (it entities.Params) entities.Params {
			return entities.Params{
				name: it.name
				typ: resolver_name_type(it.typ, base_module)
			}
		})

		line_param_delegate := parameter_resolveds.map(fn (it entities.Params) string {
			return if it.typ == 'VString' {
				'VStringInterop ${it.name}'
			} else {
				'${it.typ} ${it.name}'
			}
		}).join(', ')

		names_param := node_delegate.params.map(fn (it entities.Params) string {
			return if it.typ.contains('string') {
				'${it.name}.ToVStringInterop()'
			} else {
				it.name
			}
		}).join(', ')

		value_return_fn := match type_fn {
			'string' {
				'new VString(_${name_fn}(${names_param}))'
			}
			'int', 'float', 'double', 'void' {
				'_${name_fn}(${names_param})'
			}
			else {
				'new ${type_fn}(_${name_fn}(${names_param}))'
			}
		}

		line_param := parameter_resolveds.map(fn (it entities.Params) string {
		return '${it.typ} ${it.name}'
	}).join(', ')

		mut data := map[string]veemarker.Any{}
		data['type_delegate'] = veemarker.Any(type_delegate)
		data['name_delegate'] = veemarker.Any(name_delegate)
		data['line_param_delegate'] = veemarker.Any(line_param_delegate)

		println('-> ${name_delegate}')
		code_struct := engine.render('ImplDelegates.cs', data) or {
			eprintln('Template error (ImplDelegates): ${err}')
			''
		}

		mut data_prop := map[string]veemarker.Any{}
		data_prop['name_delegate'] = veemarker.Any(name_delegate)
		data_prop['name_fn'] = veemarker.Any(name_fn)
		data_prop['type_fn'] = veemarker.Any(type_fn)
		data_prop['line_param'] = veemarker.Any(line_param)
		data_prop['value_return_fn'] = veemarker.Any(value_return_fn)

		code_prop := engine.render('ImplPropertyFromDelegates.cs', data_prop) or {
			eprintln('Template error (ImplPropertyFromDelegates): ${err}')
			''
		}

		code_struct_combined := code_struct + '\n' + code_prop

		ext.delegates[name_delegate] = Delegate{
			name_function_dl: pure_name_fn
			name_var_function: '_${name_fn}'
			content: code_struct_combined
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