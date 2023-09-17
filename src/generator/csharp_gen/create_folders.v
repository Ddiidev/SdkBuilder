module csharp_gen

import os

fn create_folders(dirs ...string) {
	println('\n-- Create folders --')
	for dir in dirs {
		println(dir)
		os.mkdir_all(dir) or { println('Fail create folder "${dir}"') }
	}
}
