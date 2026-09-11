extends Object

class_name BBCode

static func center(string: String) -> String:
	return "[center]%s[/center]"%string

static func underline(string: String) -> String:
	return "[u]%s[/u]"%string

static func font_size(string: String, size: int) -> String:
	return "[font_size=%s]%s[/font_size]"%[var_to_str(size), string]
