extends Object

class_name Token

var _token_data : TokenData
var artwork : Texture2D:
	get: return _token_data.artwork
var tag : Const.Tag:
	get: return _token_data.tag

func _init(token_data: TokenData):
	_token_data = token_data

