module parser

import ast
pub fn (mut p Parser) stmt(is_top_level bool) ast.Stmt {
	match p.tok.kind {
		.name {
			if p.peek_tok.kind == .lpar {
				return p.expr_stmt(p.call_expr())
			} else if p.peek_tok.kind == .decl_assign {
				return p.assign_stmt(.decl_assign)
			}
			
			return p.unknown()
		}
		
		else {
			return p.unknown()
		}
	}
}