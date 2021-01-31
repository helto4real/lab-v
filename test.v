struct Test {
	number int
	a_string string
}
fn main() {
	x := 'Hello world'
	y := u64(10)
	println(x)
	println('test')
	no_leak := 'It is a $x and a $y'
	println(no_leak)
	no_leak.free()
}
