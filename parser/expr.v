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
	name := p.tok.lit 
	if p.peek_tok.kind == .dot && p.peek_tok2.kind == .name {
		p.scan_next_token()
		p.scan_next_token()
		full_name :='${name}.${p.tok.lit}'
		return ast.Ident{
			name: full_name
		}
	}
	return ast.Ident{
		name: name
	}
}
