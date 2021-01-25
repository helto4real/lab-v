module parser

import ast

fn (mut p Parser) expr_stmt(expr ast.Expr) ast.Stmt {
	return ast.ExprStmt{
		expr: expr
	}
}

fn (mut p Parser) call_expr() ast.Expr {
	mut args := []ast.CallArg{}
	if p.tok.kind != .name {
		println('NOT A NAME')
		return p.unknown()
	}
	fn_name := p.tok.lit
	p.scan_next_token()
	if p.tok.kind != .lpar {
		println('NOT A LPAR')
		return p.unknown()
	}
	p.scan_next_token()
	expr := p.expr()
	if !(expr is ast.Empty) {
		args << ast.CallArg{
			expr: expr
		}
	}
	p.scan_next_token()
	if p.tok.kind != .rpar {
		return p.unknown()
	}
	return ast.CallExpr{
		name: fn_name
		args: args
		mod: p.mod
	}
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
