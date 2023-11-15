module entities

import contract { TypeGenerate }

pub struct SdkBuilderConfiguration {
pub:
	project  Project
	target   Target
	prod	 bool
}

struct Project {
pub:
	name        string
	compiler string = 'gcc'
	entry_point string = 'src/main.v'
}

struct Target {
pub:
	language  TypeGenerate
	namespace string
}
