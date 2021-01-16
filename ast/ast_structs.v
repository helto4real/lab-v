module ast

pub type Stmt = FnDecl | Unknown


pub struct Error {}

pub struct Unknown {}

pub struct FnDecl {
pub:
	name            string
	mod             string
	// params          []table.Param
	// is_deprecated   bool
	// is_pub          bool
	// is_variadic     bool
	// is_anon         bool
	// is_manualfree   bool // true, when [manualfree] is used on a fn
	// receiver        Field
	// receiver_pos    token.Position // `(u User)` in `fn (u User) name()` position
	// is_method       bool
	// method_type_pos token.Position // `User` in ` fn (u User)` position
	// method_idx      int
	// rec_mut         bool // is receiver mutable
	// rec_share       table.ShareType
	// language        table.Language
	// no_body         bool // just a definition `fn C.malloc()`
	// is_builtin      bool // this function is defined in builtin/strconv
	// pos             token.Position // function declaration position
	// body_pos        token.Position // function bodys position
	// file            string
	// is_generic      bool
	// is_direct_arr   bool // direct array access
	// attrs           []table.Attr
pub mut:
	stmts         []Stmt
	// return_type   table.Type
	// comments      []Comment // comments *after* the header, but *before* `{`; used for InterfaceDecl
	// next_comments []Comment // coments that are one line after the decl; used for InterfaceDecl
	// source_file   &File = 0
	// scope         &Scope
}