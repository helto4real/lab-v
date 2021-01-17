module scanner

fn test_scan_empty_text_result_eof() {
	mut s := new_from_text('')
	s.scan()
	assert s.pos == 1
	assert s.tokens.len == 1
	assert s.tokens[0].kind == .eof
}

fn test_scan_lpar_rpar() {
	mut s := new_from_text('()')
	s.scan()
	assert s.pos == 3
	assert s.tokens.len == 3
	assert s.tokens[0].kind == .lpar
	assert s.tokens[1].kind == .rpar
	assert s.tokens[2].kind == .eof
}
fn test_scan_lcbr_rcbr() {
	mut s := new_from_text('{}')
	s.scan()
	assert s.pos == 3
	assert s.tokens.len == 3
	assert s.tokens[0].kind == .lcbr
	assert s.tokens[1].kind == .rcbr
	assert s.tokens[2].kind == .eof
}

fn test_scan_lpar_rpar_skip_whitespace() {
	mut s := new_from_text('  \n()')
	s.scan()
	assert s.pos == 6
	assert s.tokens.len == 3
	assert s.tokens[0].kind == .lpar
	assert s.tokens[1].kind == .rpar
	assert s.tokens[2].kind == .eof
}

fn test_scan_name() {
	mut s := new_from_text('main()')
	s.scan()
	assert s.pos == 7
	assert s.tokens.len == 4
	assert s.tokens[0].kind == .name
	assert s.tokens[0].lit == 'main'
}

fn test_scan_keyword_name() {
	mut s := new_from_text('fn main()')
	s.scan()
	assert s.pos == 10
	assert s.tokens.len == 5
	assert s.tokens[0].kind == .key_fn
	assert s.tokens[0].lit == 'fn'
	assert s.tokens[1].kind == .name
	assert s.tokens[1].lit == 'main'
}

fn test_scan_fn_main() {
	mut s := new_from_text('fn main() {}')
	s.scan()
	assert s.pos == 13
	assert s.tokens.len == 7
	assert s.tokens[0].kind == .key_fn
	assert s.tokens[0].lit == 'fn'
	assert s.tokens[1].kind == .name
	assert s.tokens[1].lit == 'main'
	
	assert s.tokens[2].kind == .lpar
	assert s.tokens[2].lit == '('
	assert s.tokens[3].kind == .rpar
	assert s.tokens[3].lit == ')'

	assert s.tokens[4].kind == .lcbr
	assert s.tokens[4].lit == '{'
	assert s.tokens[5].kind == .rcbr
	assert s.tokens[5].lit == '}'
}

fn test_scan_single_qoute_literal() {
	mut s := new_from_text("'hello world'")
	t := s.scan_next_token()
	assert t.kind == .string
	assert t.lit == 'hello world'
}

fn test_scan_double_qoute_literal() {
	mut s := new_from_text('"hello world"')
	t := s.scan_next_token()
	assert t.kind == .string
	assert t.lit == 'hello world'
}