module csharp_gen

import os

fn create_files_class_sdk(ast ExtensionAst) ! {
	for struct_name, struct_content in ast.structs {
		os.write_file(os.join_path(ast.path_name_dll, '${struct_name}.cs'), struct_content)!
	}

	file_project_cs := os.join_path(ast.path_name_dll, '${ast.project_name}.cs')
	if os.exists(file_project_cs) {
		os.rm(file_project_cs)!
	}

	name_space := ast.namespace
	project_name := ast.project_name
	delegates := ast.delegates.clone()
	constructor_dl := ast.constructor_dl
	os.write_file(file_project_cs, $tmpl('./sdk_files/create_principal_class.cs'))!
}

fn create_files_class_interop(path_interop string, name_space_project string) ! {
	code_dl := $tmpl('sdk_files/Dl.cs')
	code_vstring := $tmpl('sdk_files/VString.cs')
	code_vstring_interop := $tmpl('sdk_files/VStringInterop.cs')

	os.write_file(os.join_path(path_interop, 'Dl.cs'), code_dl)!
	os.write_file(os.join_path(path_interop, 'VString.cs'), code_vstring)!
	os.write_file(os.join_path(path_interop, 'VStringInterop.cs'), code_vstring_interop)!
}
