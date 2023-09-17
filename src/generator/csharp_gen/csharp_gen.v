module csharp_gen

import entities { Ast, SdkBuilderConfiguration }
import os

pub struct CSharpGenerator {
	conf       SdkBuilderConfiguration
	path_lib_v string
	ast_v      Ast
}

pub fn (this CSharpGenerator) generate() ! {
	path_project := os.join_path(@VMODROOT, 'projects_sdk', 'csharp', '${this.conf.target.namespace}Interop')
	path_interop := os.join_path(path_project, 'Interop')
	path_name_dll := os.join_path(path_project, this.conf.project.name)

	create_folders(path_project, path_interop, path_name_dll)

	mut ast := ExtensionAst{
		ast: this.ast_v
		path_name_dll: path_name_dll
		namespace: this.conf.target.namespace
		project_name: this.conf.project.name
	}

	implement_calls_sdk(mut ast)
	implement_constructor(mut ast)
	create_files_class_sdk(ast)!
	create_files_class_interop(path_interop, this.conf.target.namespace)!
	this.compile_dll(path_name_dll)!
}
