module scanner
import token

fn (mut s Scanner) token_end_of_file() token.Token
{
 	return s.new_token(.eof, '', 1)
}

fn (mut s Scanner) token_unknown() token.Token {
	return s.new_token(.unknown, '', 1)
}

fn (mut s Scanner) token_lcbr() token.Token {
	return s.new_token(.lcbr, '{', 1)
}

fn (mut s Scanner) token_rcbr() token.Token {
	return s.new_token(.rcbr, '}', 1)
}

fn (mut s Scanner) token_lpar() token.Token {
	return s.new_token(.lpar, '(', 1)
}

fn (mut s Scanner) token_rpar() token.Token {
	return s.new_token(.rpar, ')', 1)
}


fn (mut s Scanner) token_name(name string) token.Token {
	return s.new_token(.name, name, name.len)
}

fn (mut s Scanner) token_keyword(kind token.Kind, lit string) token.Token {
	return s.new_token(kind, lit, lit.len)
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