module gen 

import parser
import ast
import strings

pub struct Gen {
pub mut:
	b strings.Builder
}

pub fn cgen(p &parser.Parser) string {
	mut g := Gen {
		b: strings.new_builder(1000)
	}
	g.b.writeln(std_include)
	for _, s in p.top_lev_stmts {
		match s {
			ast.FnDecl {
				g.gen_fn(s)
			} 
			else {

			}
		}
	}

	g.b.writeln(main_c)
	return g.b.str()
}

fn (mut g Gen) gen_fn(fd ast.FnDecl) {
	g.b.writeln('void v_${fd.mod}_${fd.name}() {')
	g.b.writeln('printf("C Programming");')
	g.b.writeln('}')
}