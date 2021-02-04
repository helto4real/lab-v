module parser
import ast 

fn test_parse_first_top_stmt() {
	mut table := table.new_table()
	mut p := new_from_text('fn main() {}')

	p.init_scan()
	top := p.scan_next_top_stmt()

	assert top is ast.FnDecl

	if top is ast.FnDecl {
		assert top.name == 'main'
	}
}