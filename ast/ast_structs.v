module ast

import token
import table

pub type Stmt = AssignStmt | ExprStmt | FnDecl | Unknown

pub type Expr = CallExpr | Empty | Ident | StringLiteral | Unknown

pub struct Error {}

pub struct Unknown {}

pub struct Empty {}

pub struct FnDecl {
pub:
	name string
	mod  string
	// params          []table.Param
pub mut:
	stmts []Stmt
}

// function or method call expr
pub struct CallExpr {
pub:
	// pos  token.Position
	// left Expr // `user` in `user.register()`
	mod string
pub mut:
	name string // left.name()
	args []CallArg
}

pub struct ExprStmt {
pub:
	expr Expr
	// pub mut:
	// typ table.Type
}

pub struct CallArg {
pub:
	// is_mut   bool
	expr Expr
	// pub mut:
	// typ             table.Type
	// tmp_name        string // for autofree
}

pub struct StringLiteral {
pub:
	val string
	// is_raw   bool
	// language table.Language
	// pos      token.Position
}

pub struct AssignStmt {
pub:
	op token.Kind // include: =,:=,+=,-=,*=,/= and so on; for a list of all the assign operators, see vlib/token/token.v
pub mut:
	right []Expr
	left  []Expr
	// left_types    []table.Type
	// right_types   []table.Type
	// is_static     bool // for translated code only
	// is_simple     bool // `x+=2` in `for x:=1; ; x+=2`
	// has_cross_var bool
}

pub struct Ident {
pub:
	tok_kind token.Kind
pub mut:
	name string
	typ  table.Type = .unknown
}
