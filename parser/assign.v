module parser

import token
import ast

pub fn (mut p Parser) assign_stmt(kind token.Kind) ast.Stmt {
	println('HELLO')
	mut expr_left := ast.Expr{}

	if p.tok.kind == .name {
		expr_left = p.ident(p.tok.lit)

		mut ret := ast.AssignStmt{}
		ret.left << expr_left
		p.scan_next_token()
		p.scan_next_token()
		match p.tok.kind {
			.string { ret.right << p.expr() }
			else {}
		}
		return ret
	}
	return ast.Stmt{}
}

pub fn (mut p Parser) ident(name string) ast.Ident {
	return ast.Ident{
		name: name
		typ: .string
	}
}
