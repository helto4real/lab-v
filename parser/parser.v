module parser

import ast 
import scanner 
import token

pub struct Parser {
mut:
	scanner 	&scanner.Scanner
	tok         token.Token
	mod			string
pub mut:
	top_lev_stmts []ast.Stmt
}

pub fn new_from_text(text string) &Parser{
	return &Parser{
		scanner: 	scanner.new_from_text(text)
		mod: 		'main' // Use default main
	}
}

pub fn (mut p Parser) parse() {
	mut statements := []ast.Stmt{}
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
		else {return ast.Unknown{}}
	}
	return ast.Unknown{}
}

fn (mut p Parser) scan_next_token() {
	// p.prev_tok = p.tok
	p.tok = p.scanner.scan_next_token()
	// p.peek_tok = p.peek_tok2
	// p.peek_tok2 = p.peek_tok3
	// p.peek_tok3 = p.scanner.scan()
	/*
	if p.tok.kind==.comment {
		p.comments << ast.Comment{text:p.tok.lit, line_nr:p.tok.line_nr}
		p.next()
	}
	*/
}