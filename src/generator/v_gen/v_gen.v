module v_gen

import entities { Ast, SdkBuilderConfiguration }

pub struct VGenerator {
	conf       SdkBuilderConfiguration
	path_lib_v string
	ast_v      Ast
}

pub fn (this VGenerator) generate() ! {
}
