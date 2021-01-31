module parser

import ast

fn (mut p Parser) expr() ast.Expr {
	match p.tok.kind {
		.rpar {
			return ast.Empty{}
		}
		.string {
			return ast.StringLiteral{
				val: p.tok.lit
			}
		}
		.name {
			return p.name_expr()
		}
		else {
			return p.unknown()
		}
	}
}

fn (mut p Parser) name_expr() ast.Expr {
	return ast.Ident{
		name: p.tok.lit
	}
}
