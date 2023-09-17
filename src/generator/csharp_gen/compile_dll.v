module csharp_gen

import os

fn (this CSharpGenerator) compile_dll(path_name_dll string) ! {
	os.execute('v -cc ${this.conf.compiler} -prod -shared "${this.path_lib_v}" -o "${path_name_dll}/${this.conf.project.name}.dll"')
}
