extends Node

class_name SuitTrack3D

@export var slots : Array[Node]
@export var suit : Suit
var tokens_3d: Array[Token3D]

func get_slot():
	return slots[tokens_3d.size()] if slots.size() >= tokens_3d.size() else null

func remove_token(token : Token):
	pass

func remove_token_at(index : int):
	if index >= tokens_3d.size():
		return
	
	tokens_3d[index].queue_free()
	tokens_3d.remove_at(index)
	
	if range(index, tokens_3d.size()).size() <= 0: return
	
	var tween = get_tree().create_tween().set_parallel()
	
	for i in range(index, tokens_3d.size()):
		tween.tween_property(tokens_3d[i], "global_position", slots[i].global_position +  + Vector3(0,.002,0), .4) \
		.set_trans(Tween.TRANS_SPRING) \
		.set_ease(Tween.EASE_OUT)
	
	await tween.finished
