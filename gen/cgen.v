module gen

import ast
import strings
import table

pub struct Gen {
pub mut:
	b         strings.Builder
	tab_index int
}

pub fn cgen(mut tab table.Table, mut file ast.File) string {
	mut g := Gen{
		b: strings.new_builder(1000)
	}
	g.b.writeln(std_include)
	// g.b.writeln(built_in_types)
	// g.b.writeln(built_in_structs)
	// g.b.writeln(built_in_functions)
	for _, s in file.stmts {
		match s {
			ast.FnDecl { g.gen_fn(s) }
			else {}
		}
	}

	g.b.writeln(main_c)
	return g.b.str()
}

fn (mut g Gen) gen_assign(asn ast.AssignStmt) {
	// just hardcode to one string literal now
	right := asn.right[0]
	left := asn.left[0]
	println(right)
	println(left)
	match right {
		ast.StringLiteral {
			if left is ast.Ident {
				g.writeln_indent('string $left.name =_SLIT("$right.val");')
			}
		}
		else {}
	}
}

fn (mut g Gen) gen_fn(fd ast.FnDecl) {
	g.b.writeln('void v_${fd.mod}_${fd.name}() {')
	g.tab_index++
	for _, s in fd.stmts {
		match s {
			ast.ExprStmt {
				match s.expr {
					ast.CallExpr { g.gen_call_expr(s.expr) }
					else {}
				}
			}
			ast.AssignStmt {
				g.gen_assign(s)
			}
			else {}
		}
	}
	g.tab_index--
	// g.b.writeln('printf("C Programming");')
	g.b.writeln('}')
}

fn (mut g Gen) gen_call_expr(ce ast.CallExpr) {
	g.write_indent('${ce.name}(')
	for i, arg in ce.args {
		expr := arg.expr
		if i > 0 {
			g.write(', ')
		}
		match expr {
			ast.StringLiteral {
				g.write('_SLIT("$expr.val")')
			}
			ast.Ident {
				// if expr.typ == .string {
				g.write(expr.name)
				// }
			}
			else {
				println('Unexpected expression: $expr.type_name()')
			}
		}
	}
	g.writeln(');')
}
