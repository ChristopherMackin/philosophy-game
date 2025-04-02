extends TextureRect

class_name TokenGUI

var token : Token:
	get: return token
	set(val):
		token = val
		if val != null:
			_set_texture(token)

func _set_texture(token : Token):
	texture = token.artwork
