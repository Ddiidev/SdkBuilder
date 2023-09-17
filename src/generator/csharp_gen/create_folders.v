module csharp_gen

import os

fn create_folders(dirs ...string) {
	for dir in dirs {
		os.mkdir_all(dir) or { println('Fail create folder "${dir}"') }
	}
}
