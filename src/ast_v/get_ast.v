module ast_v

import entities { Ast }
import os
import json

// get Return Ast file_path.v
pub fn get(_file_path string) !Ast {
	mut file_path := _file_path
	if file_path.starts_with('"') {
		file_path = file_path[1..]
	}
	if file_path.ends_with('"') {
		file_path = file_path#[0..-1]
	}

	println('Generate AST for "${file_path}"')
	result := os.execute('v ast -p --hide "imports,auto_imports,imported_symbols,embedded_files,global_labels,mod,is_noreturn,is_manualfree" -t "${file_path}"')

	if result.exit_code > 0 {
		return error(result.output)
	}

	return json.decode(Ast, result.output)!
}
