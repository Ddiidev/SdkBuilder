module main

import builder_sdk
import os

fn main() {
	file_conf_sdk := os.args[1] or { r'C:\Users\AndreLuiz\Documents\SourceApps\Vlang\SdkTest\sdkbuilder.json' }
	println('Building SDK')
	builder_sdk.construct(file_conf_sdk)!
}
