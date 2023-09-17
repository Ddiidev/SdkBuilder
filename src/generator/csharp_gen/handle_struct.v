module csharp_gen

pub struct Props {
pub:
	name         string
	typ          string
	relation_typ string
}

fn (mut ex_ast ExtensionAst) handle_struct() {
	base_module := if ex_ast.ast.stmts.first().ast_type == 'Module' {
		ex_ast.ast.stmts.first().name
	} else {
		''
	}

	usings := [
		'${ex_ast.namespace}.Interop',
	]
	name_space := ex_ast.namespace
	project_name := ex_ast.project_name
	for node_struct in ex_ast.ast.stmts.filter(it.ast_type == 'StructDecl') {
		mut props := []Props{}
		name_struct := if node_struct.name.contains('${base_module}.') {
			node_struct.name[base_module.len + 1..]
		} else {
			node_struct.name
		}

		props << node_struct.fields.map(Props{
			typ: it.typ
			name: it.name
			relation_typ: if it.typ == 'string' {
				'VString'
			} else {
				''
			}
		})

		arguments := '${name_struct}Interop _arg'

		code_struct := $tmpl('sdk_files/ImplStruct.cs').replace('\n\n', '\n')

		ex_ast.structs[name_struct] = code_struct
	}
}
