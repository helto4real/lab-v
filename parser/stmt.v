module parser

import ast

pub fn (mut p Parser) stmt(is_top_level bool) ast.Stmt {
	match p.tok.kind {
		.name {
			if p.peek_tok.kind == .lpar {
				return p.expr_stmt(p.call_expr())
			} else if p.peek_tok.kind == .decl_assign {
				// name := 
				return p.assign_stmt(.decl_assign)
			} else if p.peek_tok.kind == .dot && p.peek_tok2.kind == .name && p.peek_tok3.kind == .assign  {
				// name.name :=
				return p.assign_stmt(.assign)
			}
			
			return p.unknown()
		}
		else {
			return p.unknown()
		}
	}
}
