extends Node3D

class_name TokenTrack3d

@export var suit: Suit
@export var token_offset: Vector3
@export var token_count: int = 10
@onready var placeholder_token: InstancePlaceholder = $Token3d

var tokens_3d: Array[Token3d]
var tokens: Array[Token]:
	get(): return tokens_3d.map(func(x): return x.token) if tokens_3d.size() > 0 else []

func update_token_track(token_array: Array[Token]):
	for token_3d in tokens_3d:
		if !token_3d.token in token_array:
			var index = tokens_3d.find(token_3d)
			tokens_3d.remove_at(index)
			token_3d.queue_free()
	
	var new_tokens = token_array.filter(func(x): return !x in tokens)
		
	for token in new_tokens:
		var token_3d: Token3d = placeholder_token.create_instance()
		token_3d.position += token_offset * tokens_3d.size()
		token_3d.token = token
		tokens_3d.append(token_3d)
		
