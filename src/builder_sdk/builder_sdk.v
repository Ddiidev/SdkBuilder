module builder_sdk

import entities { SdkBuilderConfiguration }
import generator.v_gen
import generator.csharp_gen
import ast_v
import json
import os

pub fn construct(file_conf string) ! {
	content_file_conf := os.read_file(file_conf)!
	conf := json.decode(SdkBuilderConfiguration, content_file_conf)!
	root_path := file_conf.split(os.path_separator)#[0..-1].join(os.path_separator)
	full_path := os.join_path(root_path, conf.project.entry_point)

	println("Reading file conf. sdk")

	ast := ast_v.get(full_path)!

	println("Generating sdk, language target: ${conf.target.language}")

	match conf.target.language {
		.v {
			v_gen.VGenerator{
				conf: conf
				path_lib_v: root_path
				ast_v: ast
			}.generate()!
		}
		.csharp {
			csharp_gen.CSharpGenerator{
				conf: conf
				path_lib_v: root_path
				ast_v: ast
			}.generate()!
		}
	}
}
