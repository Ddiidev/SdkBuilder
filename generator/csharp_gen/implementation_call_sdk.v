module csharp_gen

fn implement_calls_sdk(mut ast ExtensionAst) {
	ast.handle_struct()
	ast.handle_delegates()
}
