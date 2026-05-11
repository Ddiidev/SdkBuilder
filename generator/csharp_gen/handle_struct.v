module csharp_gen

import leafscale.veemarker

pub struct Props {
pub:
	name         string
	typ          string
	relation_typ string
}

fn (mut ext ExtensionAst) handle_struct(mut engine veemarker.Engine) {
	println('\n -- Implementing structs -- ')
	base_module := if ext.ast.stmts.first().ast_type == 'Module' {
		ext.ast.stmts.first().name
	} else {
		''
	}

	usings := [
		'${ext.namespace}.Interop',
	]
	name_space := ext.namespace
	project_name := ext.project_name
	for node_struct in ext.ast.stmts.filter(it.ast_type == 'StructDecl') {
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

		println('-> $name_struct')

		mut props_data := []veemarker.Any{}
		for prop in props {
			mut prop_map := map[string]veemarker.Any{}
			prop_map['name'] = veemarker.Any(prop.name)
			prop_map['typ'] = veemarker.Any(prop.typ)
			prop_map['relation_typ'] = veemarker.Any(prop.relation_typ)
			props_data << veemarker.Any(prop_map)
		}

		mut usings_data := []veemarker.Any{}
		for u in usings {
			usings_data << veemarker.Any(u)
		}

		mut data := map[string]veemarker.Any{}
		data['usings'] = veemarker.Any(usings_data)
		data['full_namespace'] = veemarker.Any('${name_space}.${name_space}Interop.${project_name}')
		data['name_struct'] = veemarker.Any(name_struct)
		data['props'] = veemarker.Any(props_data)
		data['arguments'] = veemarker.Any(arguments)
		data['arg_prefix'] = veemarker.Any('_arg.')

		mut code_struct := engine.render('ImplStruct.cs', data) or {
			eprintln('Template error (ImplStruct): ${err}')
			''
		}

		code_struct = code_struct.replace('\n\n', '\n')

		ext.structs[name_struct] = code_struct
	}
}