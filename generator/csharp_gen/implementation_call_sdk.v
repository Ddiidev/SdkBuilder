module csharp_gen

import leafscale.veemarker

fn implement_calls_sdk(mut ast ExtensionAst, mut engine veemarker.Engine) {
	ast.handle_struct(mut engine)
	ast.handle_delegates(mut engine)
}