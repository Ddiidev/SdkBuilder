module csharp_gen

import os

fn (this CSharpGenerator) compile_dll(path_name_dll string) ! {
	println('\n\nCompiling the V library...')
	println('-> Name : ${(this.conf.project.name)}')
	println('-> Language : ${(this.conf.target.language)}')
	println('-> Compiler : ${this.conf.compiler}')
	println('-> Production : ${this.conf.prod}')
	prod := if this.conf.prod { ' -prod' } else { '' }
	res := os.execute('v -cc ${this.conf.compiler} $prod -shared "${this.path_lib_v}" -o "${path_name_dll}/${this.conf.project.name}.dll"')
	if res.exit_code != 0 {
		return error('Failed to compile the V library | err: ${res.output}')
	}
}
