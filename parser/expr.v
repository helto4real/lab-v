module parser

import ast

fn (mut p Parser) expr() ast.Expr {
	match p.tok.kind {
		.rpar { return ast.Empty{} }
		.string { return ast.StringLiteral{
				val: p.tok.lit
			} }
		else { return p.unknown() }
	}
}
