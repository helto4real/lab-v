module parser

import ast

// struct_decl parses a struct declaration 
// 	struct {
//		field_name field_type
//	}
fn (mut p Parser) struct_decl() ast.Stmt {
	p.assert_token(.key_struct)
	p.scan_next_token()

	if !p.check_token_kind(.name, 'Expected a name after struct') {
		return p.unknown()
	}
	name := p.tok.lit

	p.scan_next_token()

	if !p.check_token_kind(.lcbr, 'Expected a `{` after name') {
		return p.unknown()
	}

	fields := p.struct_fields()

	return ast.StructDecl{
		name: name
		fields: fields
	}
}

fn (mut p Parser) struct_fields() []ast.StructField {
	mut fields := []ast.StructField{}
	p.scan_next_token()

	for {
		if p.tok.kind == .rcbr {
			return fields
		}
		if p.tok.kind == .eof {
			println('UNEXPECTED END OF FILE PARSING STRUCT FIELDS')
			return fields
		}

		if !p.check_token_kind(.name, 'Expected a name of field in struct') {
			println('EXPECTED NAME OF FIELD')
			return fields
		}
		field_name := p.tok.lit
		p.scan_next_token()
		if !p.check_token_kind(.name, 'Expected Expected a type of field in struct') {
			println('EXPECTED TYPE OF FIELD')
			return fields
		}
		field_type := p.tok.lit
		p.scan_next_token()
		fields << ast.StructField{
			name: field_name
			field_type: field_type
		}
	}
	return fields
}
