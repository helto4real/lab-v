module scanner

import token

pub struct Scanner {
pub mut:
	text	string
	pos 	int
	tokens 	[]token.Token
}

// pub fn new_from_file(file_path string) {
// 	mut raw_text := os.read_file(file_path) or { return error('failed to open $file_path') }
// 	return new_from_text(raw_text)
// }

pub fn new_from_text(text string) &Scanner {
	mut s := &Scanner{
		text: text
	}
	return s
}

pub fn (mut s Scanner) scan() {
	for {
		t := s.scan_next_token()
		s.tokens << t
		if t.kind == token.Kind.eof {
			break
		}
	}
}

pub fn (mut s Scanner) scan_next_token() token.Token
{
	for {
		s.skip_whitespace()
		if s.pos >= s.text.len {
			return s.token_end_of_file()
		}

		c := s.text[s.pos]
		if is_name_char(c) {
			name := s.ident_name()
			kind := token.keywords[name]
			if kind == .unknown {
				return s.token_name(name)
			} else {
				return s.token_keyword(kind, name)
			}
		} else if c == `(` {
			return s.token_lpar()
		} else if c == `)` {
			return s.token_rpar()
		} else if c == `{` {
			return s.token_lcbr()
		} else if c == `}` {
			return s.token_rcbr()
		} else {
			return s.token_unknown()
		}
	}
	return s.token_unknown()
}

[inline]
fn (mut s Scanner) skip_whitespace() {
	for s.pos < s.text.len && s.text[s.pos].is_space() {
		// if is_nl(s.text[s.pos]) && s.is_vh {
		// 	return
		// }
		// Count \r\n as one line
		// if util.is_nl(s.text[s.pos]) && !s.expect('\r\n', s.pos - 1) {
		// 	s.inc_line_number()
		// }
		s.pos++
	}
}


[inline]
pub fn is_nl(c byte) bool {
	return c == `\r` || c == `\n`
}

[inline]
pub fn is_name_char(c byte) bool {
	return (c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`) || c == `_`
}

[inline]
fn (mut s Scanner) ident_name() string {
	start := s.pos
	s.pos++
	for s.pos < s.text.len && (is_name_char(s.text[s.pos]) || s.text[s.pos].is_digit()) {
		s.pos++
	}
	name := s.text[start..s.pos]
	s.pos--
	return name
}