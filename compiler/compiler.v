module main

// import v.parser
// import v.table
// import v.pref
// import v.ast
import parser
import gen
import os
// import ast
import table
import pref
// const (
// 	code = "

// struct MyStruct {
// 	test string
// }

// fn main() {
// 	x := 'hello world'
// 	println('testar')
// 	println(x)

	
// }

// "
// )

fn main() {
	args := os.args[1..]

	pref := pref.parse_args(args)

	mut source := os.read_file(pref.path) ?
	mut table := table.new_table()
	mut p := parser.new_from_text(source, mut table)
	mut file := p.parse()
	tmpfile := '${pref.path}.c'
	println('Compiling: ${pref.path}')
	mut f := os.open_file(tmpfile, 'w+', 0o666) ?
	defer {
		f.close()
	}
	f.write_string(gen.cgen(mut table, mut file)) ?
	f.flush()
	output := pref.path.split('.')[0]

	cc := 'cc ${pref.path}.c -I "./gen/c/include" -L "./gen/c/lib" ./gen/c/lib/default.o -v -o $output' 
	// println(cc)
	os.exec(cc) or {
		eprintln('Compile error: $err')
		exit(-1)
	}
	println('done')
	// println('TOP LEVEL STATEMENTS:')
	// for _, s in file.stmts {
	// 	match s {
	// 		ast.FnDecl {
	// 			for _, c in s.stmts {
	// 				println('stmt: $c')
	// 			}
	// 		}
	// 		ast.StructDecl {
	// 			println('struct: $s')
	// 		}
	// 		else {}
	// 	}
	// }
}
