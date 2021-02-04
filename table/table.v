module table

pub struct Table {
pub mut:
	types     []TypeSymbol
	type_idxs map[string]int
}

// pub enum Type {
// 	string
// 	unknown
// }

pub fn new_table() &Table {
	mut t := &Table{}
	t.register_builtin_type_symbols()
	// t.is_fmt = true
	return t
}

[inline]
pub fn (mut t Table) register_type_symbol(typ TypeSymbol) int {
	// println('register_type_symbol( $typ.name )')
	existing_idx := t.type_idxs[typ.name]
	if existing_idx > 0 {
		ex_type := t.types[existing_idx]
		match ex_type.kind {
			.unknown {
				// override placeholder
				// println('overriding type placeholder `$typ.name`')
				t.types[existing_idx] = TypeSymbol{
					...typ
				}
				return existing_idx
			}
			else {
				// hello
				// builtin
				// this will override the already registered builtin types
				// with the actual v struct declaration in the source
				if existing_idx >= string_type_idx && existing_idx <= map_type_idx {
					if existing_idx == string_type_idx {
						// existing_type := t.types[existing_idx]
						t.types[existing_idx] = TypeSymbol{
							...typ
							kind: ex_type.kind
						}
					} else {
						t.types[existing_idx] = typ
					}
					return existing_idx
				}
				return -1
			}
		}
	}
	typ_idx := t.types.len
	t.types << typ
	t.type_idxs[typ.name] = typ_idx
	return typ_idx
}
