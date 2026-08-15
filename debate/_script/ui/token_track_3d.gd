extends Node3D

class_name TokenTrack3d

@export var suit: Suit
@export var token_offset: Vector3
@export var token_count: int = 10
@onready var placeholder_token: InstancePlaceholder = $Token3d

var tokens_3d: Array[Token3d]
var tokens: Array[Token]:
	get(): return tokens_3d.map(func(x): return x.token) if tokens_3d.size() > 0 else []

func remove_tokens(token_array: Array[Token]) -> bool:
	var remove_tokens := false
	for token_3d: Token3d in tokens_3d:
		if !token_3d.token in token_array:
			remove_tokens = true
			var index = tokens_3d.find(token_3d)
			tokens_3d.remove_at(index)
			token_3d.destroy_token()
	
	return remove_tokens

func add_tokens(token_array: Array[Token]) -> bool:
	var new_tokens = token_array.filter(func(x): return !x in tokens)
	
	if new_tokens.size() <= 0: return false
	
	for token in new_tokens:
		var token_3d: Token3d = placeholder_token.create_instance()
		token_3d.position += token_offset * tokens_3d.size()
		token_3d.token = token
		tokens_3d.append(token_3d)
	
	return true

func move_tokens(token_array: Array[Token]) -> bool:
	var pos = Vector3.ZERO
	var stored_values = placeholder_token.get_stored_values()
	if "transform" in stored_values:
		pos = stored_values["transform"].origin
	
	var moved_token = false
	
	var i = 0
	for token in token_array:
		var index = tokens.find(token)
		var token3d:= tokens_3d[index]
		if token3d.position != pos + token_offset * i:
			token3d.reposition_token(pos + token_offset * i)
			moved_token = true
		i += 1
	
	return moved_token
