module parser

import token
import ast
import table

pub fn (mut p Parser) assign_stmt(kind token.Kind) ast.Stmt {
	mut expr_left := ast.Expr{}

	p.assert_token(.name)
	if p.tok.kind == .name {
		expr_left = p.ident()

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
			.name {
				if p.peek_tok.kind == .lcbr {
					ret.right << p.struct_init(false)
					// We have a struct declaration
					// p.scan_next_token()
					// p.scan_next_token()
				}
			}
			else {}
		}
		return ret
	}
	return ast.Stmt{}
}

pub fn (mut p Parser) ident() ast.Ident {
	mut name := p.tok.lit
	if p.peek_tok.kind == .dot && p.peek_tok2.kind == .name  {
		// The identifier has a module.ident name
		p.scan_next_token()
		p.scan_next_token()
		ident_name := '${name}.${p.tok.lit}'
		return ast.Ident{
			name: ident_name
			tok_kind: p.peek_tok.kind 
			kind: .string
			
		}
	}
	return ast.Ident{
		name: name
		kind: .string
		tok_kind: p.peek_tok.kind 
	}
}
