module main

// import v.parser
// import v.table
// import v.pref
// import v.ast
import parser
import gen
import os
import ast

const (
	code = "

struct MyStruct {
	test string
}

fn main() {
	x := 'hello world'
	println('testarr')
	println(x)
}

"
)

fn main() {
	mut p := parser.new_from_text(code)
	p.parse()
	mut f := os.open_file('./main.c', 'w+', 0o666) ?
	defer {
		f.close()
	}
	f.write_string(gen.cgen(p)) ?

	println('TOP LEVEL STATEMENTS:')
	for _, s in p.top_lev_stmts {
		match s {
			ast.FnDecl {
				for _, c in s.stmts {
					println('stmt: $c')
				}
			}
			ast.StructDecl {
				println('struct: $s')
			}
			else {}
		}
	}
}

// fn main() {
// 	mut table := table.new_table()
// 	// checker := checker.new_checker(table, prefs)
// 	mut prefs := pref.new_preferences()
// 	file_ast := parser.parse_file('./test.v', table, .parse_comments, prefs, &ast.Scope{ parent: 0})
// 	fnr := file_ast.stmts[1]
// 	if fnr is ast.FnDecl {
// 		x := fnr.stmts[0]
// 		println('AST: ${x}')
// 	}
// }
