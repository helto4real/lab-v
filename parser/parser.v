module parser

import ast
import scanner
import token

pub struct Parser {
mut:
	scanner  &scanner.Scanner
	tok      token.Token
	peek_tok token.Token
	prev_tok token.Token
	mod      string
pub mut:
	top_lev_stmts []ast.Stmt
}

pub fn new_from_text(text string) &Parser {
	return &Parser{
		scanner: scanner.new_from_text(text)
		mod: 'main' // Use default main
	}
}

pub fn (mut p Parser) parse() {
	mut statements := []ast.Stmt{}
	p.scan_next_token()
	for {
		p.scan_next_token()
		if p.tok.kind == .eof {
			break
		}
		statements << p.scan_next_top_stmt()
	}
	p.top_lev_stmts << statements
}

pub fn (mut p Parser) scan_next_top_stmt() ast.Stmt {
	match p.tok.kind {
		.key_fn {
			return p.fn_decl()
		}
		.key_struct {
			return p.struct_decl()
		}
		else {
			return p.unknown()
		}
	}
	return p.unknown()
}

fn (mut p Parser) init_scan() {
	p.scan_next_token()
	p.scan_next_token()
}

fn (mut p Parser) scan_next_token() {
	p.prev_tok = p.tok
	p.tok = p.peek_tok
	p.peek_tok = p.scanner.scan_next_token()
	// p.peek_tok2 = p.peek_tok3
	// p.peek_tok3 = p.scanner.scan()
	/*
	if p.tok.kind==.comment {
		p.comments << ast.Comment{text:p.tok.lit, line_nr:p.tok.line_nr}
		p.next()
	}
	*/
}

fn (mut p Parser) unknown() ast.Unknown {
	return ast.Unknown{}
}

[inline]
fn (mut p Parser) assert_token(kind token.Kind) {
	$if debug_parser ? {
		if kind != p.tok.kind {
			panic('assert_token: expected ($kind) got $p.tok.kind')
		}
	}
}

fn (mut p Parser) check_token_kind(kind token.Kind, err string) bool {
	if kind == p.tok.kind {
		return true
	}
	println('EXPECTED KIND: $kind, GOT $p.tok.kind; ERROR: $err')

	return false
}
