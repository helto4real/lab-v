import v.table
import v.ast
import v.parser
import v.pref

fn main() {
	mut table := table.new_table()
	// checker := checker.new_checker(table, prefs)
	mut prefs := pref.new_preferences()
	file_ast := parser.parse_file('./test.v', table, .parse_comments, prefs, &ast.Scope{ parent: 0})
	fnr := file_ast.stmts[1]
	if fnr is ast.FnDecl {
		for _, x in fnr.stmts {
			println('AST: ${x}')
			match x {
				ast.AssignStmt {
					println('LEFT: ${x.left[0]}, ${x.left[0].type_name()}')
					println('RIGHT: ${x.right[0]}, ${x.right[0].type_name()}')
				}
				else {

				}
			}
		}
	}
}