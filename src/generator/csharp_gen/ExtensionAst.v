module csharp_gen

import entities { Ast }

struct ExtensionAst {
	ast           Ast
	path_name_dll string
	namespace     string
	project_name  string
mut:
	structs        map[string]string
	delegates      map[string]Delegate
	constructor_dl string
}

struct Delegate {
pub:
	name_function_dl  string
	name_var_function string
	content           string
}
