import v.table
import v.ast
import v.parser
import v.pref

fn main() {
	mut table := table.new_table()
	// checker := checker.new_checker(table, prefs)
	mut prefs := pref.new_preferences()
	file_ast := parser.parse_file('./test.v', table, .parse_comments, prefs, &ast.Scope{ parent: 0})
	for _, stmt in file_ast.stmts  {
		match stmt {
			ast.FnDecl {
				for _, x in stmt.stmts {
					println('AST: ${x} : ${x.type_name()}')
					match x {
						ast.AssignStmt {
							println('LEFT: ${x.left[0]}, ${x.left[0].type_name()}')
							println('RIGHT: ${x.right[0]}, ${x.right[0].type_name()}')
						}
						ast.ExprStmt {
							if x.expr is ast.CallExpr {
								
								println('EXPR: ${x.expr.args[0].expr.type_name()}')
							}
						}
						else {}
					}
				}
			}
			ast.StructDecl {
				for _, field in stmt.fields {
					println(field)
				}
			}
			else {
				println('NOT MATCHING: ${stmt.type_name()}')	
			}
		}
	}
}