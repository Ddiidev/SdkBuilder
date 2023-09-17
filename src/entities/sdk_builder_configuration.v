module entities

import contract { TypeGenerate }

pub struct SdkBuilderConfiguration {
pub:
	project  Project
	target   Target
	compiler string = 'gcc'
	prod	 bool
}

struct Project {
pub:
	name        string
	entry_point string = 'src/main.v'
}

struct Target {
pub:
	language  TypeGenerate
	namespace string
}
