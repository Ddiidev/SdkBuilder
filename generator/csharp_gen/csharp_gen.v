module csharp_gen

import entities { Ast, SdkBuilderConfiguration }
import os
import leafscale.veemarker

pub struct CSharpGenerator {
pub:
	conf       SdkBuilderConfiguration
	path_lib_v string
	ast_v      Ast
}

pub fn (this CSharpGenerator) generate() ! {
	path_project := os.join_path(@VMODROOT, 'projects_sdk', 'csharp', '${this.conf.target.namespace}Interop')
	path_interop := os.join_path(path_project, 'Interop')
	path_name_dll := os.join_path(path_project, this.conf.project.name)

	template_dir := os.join_path(@VMODROOT, 'generator', 'csharp_gen', 'sdk_files')
	mut engine := veemarker.new_engine(veemarker.EngineConfig{
		template_dir: template_dir
		dev_mode: true
	})

	create_folders(path_project, path_interop, path_name_dll)

	mut ast := ExtensionAst{
		ast: this.ast_v
		path_name_dll: path_name_dll
		namespace: this.conf.target.namespace
		project_name: this.conf.project.name
	}

	implement_calls_sdk(mut ast, mut engine)
	implement_constructor(mut ast, mut engine)
	create_files_class_sdk(ast, mut engine)!
	create_files_class_interop(path_interop, this.conf.target.namespace, mut engine)!
	this.compile_dll(path_name_dll)!
}