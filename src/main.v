module main

import builder_sdk
import os

fn main() {
	file_conf_sdk := os.args[1] or {
		eprintln('Usage: builder_sdk <config file>')
		return
	}
	println('Building SDK')
	builder_sdk.construct(file_conf_sdk)!
}
