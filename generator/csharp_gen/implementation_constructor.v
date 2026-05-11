module csharp_gen

import leafscale.veemarker

fn implement_constructor(mut ast ExtensionAst, mut engine veemarker.Engine) {
	println('\n -- Implement constructor -- ')
	name_class_dl := ast.project_name
	name_dl_with_ext := name_class_dl + $if linux {
		'.so'
	} $else $if macos {
		'.dylib'
	} $else {
		'.dll'
	}
	path_dl_with_ext := '${ast.namespace}Interop/${ast.project_name}/${name_dl_with_ext}'
	mut functions := []FnArgImplConstructorDl{}

	for name_delegate, delegate in ast.delegates {
		functions << FnArgImplConstructorDl{
			variable_function: delegate.name_var_function
			delegate_function: name_delegate
			name_function_dl: '"${delegate.name_function_dl}"'
		}
	}

	mut functions_data := []veemarker.Any{}
	for f in functions {
		mut f_map := map[string]veemarker.Any{}
		f_map['variable_function'] = veemarker.Any(f.variable_function)
		f_map['delegate_function'] = veemarker.Any(f.delegate_function)
		f_map['name_function_dl'] = veemarker.Any(f.name_function_dl)
		functions_data << veemarker.Any(f_map)
	}

	mut data := map[string]veemarker.Any{}
	data['name_class_dl'] = veemarker.Any(name_class_dl)
	data['path_dl_with_ext'] = veemarker.Any(path_dl_with_ext)
	data['functions'] = veemarker.Any(functions_data)

	println('-> ${name_class_dl}')
	code_constructor := engine.render('ImplConstructorDl.cs', data) or {
		eprintln('Template error (ImplConstructorDl): ${err}')
		''
	}

	ast.constructor_dl = code_constructor
}

struct FnArgImplConstructorDl {
pub:
	variable_function string
	delegate_function string
	name_function_dl  string
}