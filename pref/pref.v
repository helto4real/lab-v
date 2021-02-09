module pref
struct Pref {
pub:
	path string
}

pub fn parse_args(args []string) &Pref {
	
	if args.len == 0 {return &Pref{}}
	return &Pref{path: args[0]}
}
