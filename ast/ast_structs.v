module ast

pub type Stmt = FnDecl | Unknown

pub type Expr = CallExpr | Unknown

pub struct Error {}

pub struct Unknown {}

pub struct FnDecl {
pub:
	name            string
	mod             string
	// params          []table.Param
pub mut:
	stmts         []Stmt
}

// function or method call expr
pub struct CallExpr {
pub:
	// pos  token.Position
	left Expr // `user` in `user.register()`
	mod  string
pub mut:
	name               string // left.name()
	args               []CallArg
}

pub struct CallArg {
pub:
	// is_mut   bool
	expr     Expr
// pub mut:
	// typ             table.Type
	// tmp_name        string // for autofree
}

pub struct StringLiteral {
pub:
	val      string
	// is_raw   bool
	// language table.Language
	// pos      token.Position
}