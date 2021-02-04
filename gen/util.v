module gen

[inline]
fn (mut g Gen) write(str string) {
	g.b.write(str)
}

[inline]
fn (mut g Gen) writeln(str string) {
	g.b.writeln(str)
}

[inline]
fn (mut g Gen) write_indent(str string) {
	g.add_indent()
	g.b.write(str)
}

[inline]
fn (mut g Gen) writeln_indent(str string) {
	g.add_indent()
	g.b.writeln(str)
}

[inline]
fn (mut g Gen) add_indent() {
	if g.tab_index > 0 {
		for _ in 0 .. g.tab_index {
			g.write('\t')
		}
	}
}
