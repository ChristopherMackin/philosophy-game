extends Node3D

class_name TokenTrack3d

@export var suit: Suit
@export var token_offset: Vector3
@export var token_count: int = 10
@onready var placeholder_token: InstancePlaceholder = $Token3d

var tokens_3d: Array[Token3d]

func update_token_track(token_array: Array[Token]):
	for token_3d in tokens_3d:
		token_3d.queue_free()
	
	tokens_3d.clear()
	
	var i: int = 0
	
	for token in token_array:
		var token_3d: Token3d = placeholder_token.create_instance()
		token_3d.position += token_offset * i
		token_3d.token = token
		tokens_3d.append(token_3d)
		i += 1
		
