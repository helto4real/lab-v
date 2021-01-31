module parser

import ast

pub fn (mut p Parser) parse_block_no_scope(is_top_level bool) []ast.Stmt {
	// p.check(.lcbr)
	mut stmts := []ast.Stmt{}
	if p.tok.kind != .rcbr {
		// mut count := 0
		for p.tok.kind !in [.eof, .rcbr] {
			p.scan_next_token()
			stmts << p.stmt(is_top_level)
			// count++
			// if count % 100000 == 0 {
			// 	eprintln('parsed $count statements so far from fn $p.cur_fn_name ...')
			// }
			// if count > 1000000 {
			// 	p.error_with_pos('parsed over $count statements from fn $p.cur_fn_name, the parser is probably stuck',
			// 		p.tok.position())
			// 	return []
			// }
		}
	}
	return stmts
}
