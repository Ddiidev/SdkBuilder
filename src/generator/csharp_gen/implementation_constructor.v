module csharp_gen

fn implement_constructor(mut ast ExtensionAst) {
	name_class_dl := ast.project_name
	name_dl_with_ext := name_class_dl + $if linux {
		'.so'
	} $else $if macos {
		'.dylib'
	} $else {
		'.dll'
	}
	path_dl_with_ext := '${ast.namespace}Interop/${ast.project_name}/$name_dl_with_ext'
	mut functions := []FnArgImplConstructorDl{}

	for name_delegate, delegate in ast.delegates {
		functions << FnArgImplConstructorDl{
			variable_function: delegate.name_var_function
			delegate_function: name_delegate
			name_function_dl: '"${delegate.name_function_dl}"'
		}
	}

	code_constructor := $tmpl('sdk_files/ImplConstructorDl.cs').replace('\n\n', '\n\t')
	ast.constructor_dl = code_constructor
}

struct FnArgImplConstructorDl {
pub:
	variable_function string
	delegate_function string
	name_function_dl  string
}
