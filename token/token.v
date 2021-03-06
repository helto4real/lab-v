module token

pub const (
	nr_tokens = int(Kind._end_)
	token_str = build_token_str()
	keywords  = build_keys()
)

pub struct Token {
pub mut:
	kind Kind   // the token number/enum; for quick comparisons
	lit  string // literal representation of the token
	pos  int
	len  int
}

pub enum Kind {
	unknown
	name
	number
	string
	lcbr
	rcbr
	lpar
	rpar
	colon
	dot
	assign
	decl_assign
	eof
	keyword_beg
	key_fn
	key_module
	key_struct
	keyword_end
	_end_
}

pub fn build_keys() map[string]Kind {
	mut res := map[string]Kind{}
	for t in int(Kind.keyword_beg) + 1 .. int(Kind.keyword_end) {
		key := token.token_str[t]
		res[key] = Kind(t)
	}
	return res
}

fn build_token_str() []string {
	mut s := []string{len: token.nr_tokens}
	s[Kind.unknown] = 'unknown'
	s[Kind.eof] = 'eof'
	s[Kind.name] = 'name'
	s[Kind.string] = 'string'
	s[Kind.number] = 'number'
	s[Kind.assign] = '='
	s[Kind.decl_assign] = ':='
	s[Kind.assign] = '='
	s[Kind.lcbr] = '{'
	s[Kind.rcbr] = '}'
	s[Kind.lpar] = '('
	s[Kind.rpar] = ')'
	s[Kind.dot] = '.'
	s[Kind.colon] = ':'
	s[Kind.key_fn] = 'fn'
	s[Kind.key_module] = 'module'
	s[Kind.key_struct] = 'struct'
	return s
}
