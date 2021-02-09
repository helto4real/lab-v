module scanner

import token

fn (mut s Scanner) token_end_of_file() token.Token {
	$if debug_token ? {
		println('TOKEN: EOF')
	}
	return s.new_token(.eof, '', 1)
}

fn (mut s Scanner) token_unknown() token.Token {
	$if debug_token ? {
		println('TOKEN: Unknown')
	}
	return s.new_token(.unknown, '', 1)
}

fn (mut s Scanner) token_lcbr() token.Token {
	$if debug_token ? {
		println('TOKEN: {')
	}
	return s.new_token(.lcbr, '{', 1)
}

fn (mut s Scanner) token_rcbr() token.Token {
	$if debug_token ? {
		println('TOKEN: }')
	}
	return s.new_token(.rcbr, '}', 1)
}

fn (mut s Scanner) token_lpar() token.Token {
	$if debug_token ? {
		println('TOKEN: (')
	}
	return s.new_token(.lpar, '(', 1)
}

fn (mut s Scanner) token_rpar() token.Token {
	$if debug_token ? {
		println('TOKEN: )')
	}
	return s.new_token(.rpar, ')', 1)
}

fn (mut s Scanner) token_name(name string) token.Token {
	$if debug_token ? {
		println('TOKEN: name ($name)')
	}
	return s.new_token(.name, name, name.len)
}

fn (mut s Scanner) token_string(lit string) token.Token {
	$if debug_token ? {
		println('TOKEN: string_lit ($lit)')
	}
	return s.new_token(.string, lit, lit.len) // + two quotes 
}

fn (mut s Scanner) token_keyword(kind token.Kind, lit string) token.Token {
	$if debug_token ? {
		println('TOKEN: ($kind, $lit)')
	}
	return s.new_token(kind, lit, lit.len)
}

fn (mut s Scanner) token_decl_assign() token.Token {
	$if debug_token ? {
		println('TOKEN: decl_assign (:=)')
	}
	return s.new_token(.decl_assign, ':=', 2)
}

fn (mut s Scanner) token_assign() token.Token {
	$if debug_token ? {
		println('TOKEN: assign (=)')
	}
	return s.new_token(.assign, '=', 1)
}

fn (mut s Scanner) token_colon() token.Token {
	$if debug_token ? {
		println('TOKEN: colon (:)')
	}
	return s.new_token(.colon, ':', 1)
}

fn (mut s Scanner) token_dot() token.Token {
	$if debug_token ? {
		println('TOKEN: dot (.)')
	}
	return s.new_token(.dot, '.', 1)
}

[inline]
fn (mut s Scanner) new_token(tok_kind token.Kind, lit string, len int) token.Token {
	t := token.Token{
		kind: tok_kind
		lit: lit
		pos: s.pos - len + 1
		len: len
	}
	s.pos++
	return t
}
