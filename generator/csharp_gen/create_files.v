module csharp_gen

import os
import leafscale.veemarker

fn create_files_class_sdk(ast ExtensionAst, mut engine veemarker.Engine) ! {
	println('\n -- Create files class sdk -- ')
	for struct_name, struct_content in ast.structs {
		println('-> ${struct_name}.cs')
		os.write_file(os.join_path(ast.path_name_dll, '${struct_name}.cs'), struct_content)!
	}

	file_project_cs := os.join_path(ast.path_name_dll, '${ast.project_name}.cs')
	if os.exists(file_project_cs) {
		os.rm(file_project_cs)!
	}

	mut delegates_data := []veemarker.Any{}
	for name_delegate, delegate in ast.delegates {
		mut d_map := map[string]veemarker.Any{}
		d_map['name'] = veemarker.Any(name_delegate)
		d_map['content'] = veemarker.Any(delegate.content)
		delegates_data << veemarker.Any(d_map)
	}

	mut data := map[string]veemarker.Any{}
	data['namespace_interop'] = veemarker.Any('${ast.namespace}.Interop')
	data['full_namespace'] = veemarker.Any('${ast.namespace}.${ast.namespace}Interop.${ast.project_name}')
	data['project_name'] = veemarker.Any(ast.project_name)
	data['delegates'] = veemarker.Any(delegates_data)
	data['constructor_dl'] = veemarker.Any(ast.constructor_dl)

	code := engine.render('create_principal_class.cs', data) or {
		eprintln('Template error (create_principal_class): ${err}')
		''
	}

	os.write_file(file_project_cs, code)!
}

fn create_files_class_interop(path_interop string, name_space_project string, mut engine veemarker.Engine) ! {
	println('\n -- Create files class interop -- ')
	println('-> Dl.cs')
	println('-> VString.cs')
	println('-> VStringInterop.cs')

	mut data := map[string]veemarker.Any{}
	data['namespace_interop'] = veemarker.Any('${name_space_project}.Interop')

	code_dl := engine.render('Dl.cs', data) or {
		eprintln('Template error (Dl.cs): ${err}')
		''
	}
	code_vstring := engine.render('VString.cs', data) or {
		eprintln('Template error (VString.cs): ${err}')
		''
	}
	code_vstring_interop := engine.render('VStringInterop.cs', data) or {
		eprintln('Template error (VStringInterop.cs): ${err}')
		''
	}

	os.write_file(os.join_path(path_interop, 'Dl.cs'), code_dl)!
	os.write_file(os.join_path(path_interop, 'VString.cs'), code_vstring)!
	os.write_file(os.join_path(path_interop, 'VStringInterop.cs'), code_vstring_interop)!
}