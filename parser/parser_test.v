module parser
import ast 

fn test_parse_first_top_stmt() {
	mut p := new_from_text('fn main() {}')
	p.scan_next_token()
	top := p.scan_next_top_stmt()

	assert top is ast.FnDecl

	if top is ast.FnDecl {
		assert top.name == 'main'
	}
}