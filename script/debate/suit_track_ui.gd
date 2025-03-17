extends Node

class_name SuitTrackUI

@export_group("Packed Scene")
@export var token_ui_packed_scene : PackedScene
@export var token_slot_packed_scene : PackedScene

@export_group("Track Data")
@export var suit : Suit
@export var slot_count : int

var slots : Array[Control]
var tokens_ui: Array[TokenUI]

func init(suit: Suit, slot_count: int):
	self.suit = suit
	self.slot_count = slot_count
	
	for slot in slots:
		slot.queue_free()
	
	slots.clear()
	
	for i in slot_count:
		var slot = token_slot_packed_scene.instantiate()
		add_child(slot)
		slots.append(slot)

func get_slot():
	if tokens_ui.size() >= slots.size(): return
	
	return slots[tokens_ui.size()]

func add_token(token : Token):
	var slot = get_slot()
	if slot == null: return
	
	var token_ui : TokenUI = token_ui_packed_scene.instantiate()
	token_ui.token = token
	slot.add_child(token_ui)
	
	tokens_ui.append(token_ui)

func remove_token(token : Token):
	var matching = tokens_ui.filter(func (token_ui): return token == token_ui.token)
	var token_ui = matching[0] if not matching.is_empty() else null
	var index = tokens_ui.find(token_ui)
	
	if index <0:
		return
	
	remove_token_at(index)

func remove_token_at(index : int):
	if index >= tokens_ui.size():
		return
		
	tokens_ui[index].queue_free()
	tokens_ui.remove_at(index)
	
	if range(index, tokens_ui.size()).size() <= 0: return
	
	for i in range(index, tokens_ui.size()):
		tokens_ui[i].reparent(slots[i], false)
