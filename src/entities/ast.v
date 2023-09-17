module entities

pub struct Ast {
pub:
	ast_type string
	path     string
	nr_lines int
	nr_bytes int
	is_test  bool
	stmts    []Stmts
}

pub struct Params {
pub:
	ast_type string
	name string
	typ string
	is_mut bool
}

pub struct Stmts {
pub:
	ast_type    string
	name        string
	is_skipped  bool
	fields      []Fields
	stmts       []Stmts
	params      []Params
	return_type string
}

pub struct AnonStructDecl {
pub:
	ast_type string
	name     string
	is_pub   bool
	language string
	is_union bool
}

pub struct Receiver {
pub:
	ast_type         string
	name             string
	typ              string
	anon_struct_decl AnonStructDecl
	has_default_expr bool
	is_pub           bool
	is_mut           bool
	is_global        bool
	is_volatile      bool
	is_deprecated    bool
	i                int
}

pub struct Exprs {
pub:
	ast_type string
	val      string
}

struct DefaultExpr {
pub:
	ast_type string
}

pub struct Fields {
pub:
	ast_type         string
	name             string
	typ              string
	anon_struct_decl AnonStructDecl
	has_default_expr bool
	default_expr     DefaultExpr
	is_pub           bool
	is_mut           bool
	is_global        bool
	is_volatile      bool
	is_deprecated    bool
	i                int
}

pub struct UpdateExpr {
pub:
	ast_type string
}

pub struct Expr {
pub:
	ast_type string
	val      string
}

pub struct InitFields {
pub:
	ast_type    string
	name        string
	expr        Expr
	parent_type string
}
