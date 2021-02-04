module parser

import token
import ast
import table

pub fn (mut p Parser) assign_stmt(kind token.Kind) ast.Stmt {
	mut expr_left := ast.Expr{}

	p.assert_token(.name)
	if p.tok.kind == .name {
		expr_left = p.ident(p.tok.lit)

		mut ret := ast.AssignStmt{}
		ret.left << expr_left
		p.scan_next_token()
		p.scan_next_token()
		match p.tok.kind {
			.string {
				ret.right << p.expr()
				ret.left_types << table.string_type_idx
				ret.right_types << table.string_type_idx
			}
			else {}
		}
		return ret
	}
	return ast.Stmt{}
}

pub fn (mut p Parser) ident(name string) ast.Ident {
	return ast.Ident{
		name: name
		kind: .string
	}
}
