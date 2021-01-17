module parser 
import ast

fn (mut p Parser) call_expr(mod string) ast.CallExpr {

	return ast.CallExpr{left: ast.Unknown{}}
}

// fn_decl parses function declarations
// Examples:
//	- fn main() {}
fn (mut p Parser) fn_decl() ast.FnDecl {
	// start_pos := p.tok.position()
	p.scan_next_token()
	if p.tok.kind != .name {
		return ast.FnDecl{}
	}
	name := p.tok.lit 
	p.scan_next_token()
	if p.tok.kind != .lpar {
		return ast.FnDecl{}
	}
	p.scan_next_token()
	if p.tok.kind != .rpar {
		return ast.FnDecl{}
	}
	p.scan_next_token()
	if p.tok.kind != .lcbr {
		return ast.FnDecl{}
	}
	stmts := p.parse_block_no_scope(true)
	return ast.FnDecl{
		stmts: stmts
		name: name
		mod: p.mod
	}
}