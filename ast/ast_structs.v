module ast

import token
import table

pub type Stmt = AssignStmt | ExprStmt | FnDecl | ModuleStmt | StructDecl | Unknown

pub type Expr = CallExpr | Empty | Ident | StringLiteral | StructInit | Unknown

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
	left_types    []table.Type
	right_types   []table.Type
	// is_static     bool // for translated code only
	// is_simple     bool // `x+=2` in `for x:=1; ; x+=2`
	// has_cross_var bool
}

pub struct Ident {
pub:
	tok_kind token.Kind
pub mut:
	mod  string
	name string
	kind table.Kind = .unknown
}

pub struct ModuleStmt {
pub:
	name       string // encoding.base64
	short_name string // base64
	is_skipped bool   // module main can be skipped in single file programs
}

pub struct StructDecl {
pub:
	name string
pub mut:
	fields []StructField
}

pub struct StructField {
pub mut:
	name       string
	field_type string
	typ        table.Type
}

// module declaration
pub struct Module {
pub:
	name       string // encoding.base64
	short_name string // base64
	// attrs      []table.Attr
	// pos        token.Position
	// name_pos   token.Position // `name` in import name
	// is_skipped bool // module main can be skipped in single file programs
}

// Each V source file is represented by one ast.File structure.
// When the V compiler runs, the parser will fill an []ast.File.
// That array is then passed to V's checker.
pub struct File {
pub:
	path         string // absolute path of the source file - '/projects/v/file.v'
	path_base    string // file name - 'file.v' (useful for tracing)
	mod          Module // the module of the source file (from `module xyz` at the top)
	// global_scope &Scope
pub mut:
	// scope            &Scope
	stmts            []Stmt            // all the statements in the source file
	// imports          []Import          // all the imports
	// auto_imports     []string          // imports that were implicitely added
	// embedded_files   []EmbeddedFile    // list of files to embed in the binary
	// imported_symbols map[string]string // used for `import {symbol}`, it maps symbol => module.symbol
	// errors           []errors.Error    // all the checker errors in the file
	// warnings         []errors.Warning  // all the checker warings in the file
	// generic_fns      []&FnDecl
}

pub struct StructInit {
pub:
	// pos      token.Position
	is_short bool
pub mut:
	unresolved           bool
	// pre_comments         []Comment
	typ                  table.Type
	// update_expr          Expr
	// update_expr_type     table.Type
	// update_expr_comments []Comment
	// has_update_expr      bool
	fields               []StructInitField
	// embeds               []StructInitEmbed
}

pub struct StructInitField {
pub:
	expr          Expr
	// pos           token.Position
	// comments      []Comment
	// next_comments []Comment
pub mut:
	name          string
	typ           table.Type
	expected_type table.Type
}
