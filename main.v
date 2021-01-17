module main

import parser 
import gen
import os

fn main() {
	println('test')
	x := 'a string'
	println(x)
	mut p := parser.new_from_text('fn main() {}')
	p.parse()
	mut f := os.open_file('./main.c', 'w+', 0o666) ?
	defer {f.close()}
	f.write_string(gen.cgen(p))

	// for _, s in p.top_lev_stmts {
	// 	println('token: $s')
	// }
	
}