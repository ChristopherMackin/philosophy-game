@tool
extends Node

class_name SuitTrackGUI

@export_group("Packed Scene")
@export var token_gui_packed_scene : PackedScene
@export var token_slot_packed_scene : PackedScene

@export_group("Track Data")
@export var suit : Suit:
	set(val):
		suit = val
		refresh_slots.call_deferred(suit, slot_count)
@export var slot_count : int:
	set(val):
		slot_count = val
		refresh_slots.call_deferred(suit, slot_count)

var slots : Array[Control]
var tokens_gui: Array[TokenGUI]

func refresh_slots(suit: Suit, slot_count: int):
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
	if tokens_gui.size() >= slots.size(): return
	
	return slots[tokens_gui.size()]

func add_token(token : Token):
	var slot = get_slot()
	if slot == null: return
	
	var token_gui : TokenGUI = token_gui_packed_scene.instantiate()
	token_gui.token = token
	slot.add_child(token_gui)
	
	tokens_gui.append(token_gui)

func remove_token(token : Token):
	var matching = tokens_gui.filter(func (token_gui): return token == token_gui.token)
	var token_gui = matching[0] if not matching.is_empty() else null
	var index = tokens_gui.find(token_gui)
	
	if index <0:
		return
	
	remove_token_at(index)

func remove_token_at(index : int):
	if index >= tokens_gui.size():
		return
		
	tokens_gui[index].queue_free()
	tokens_gui.remove_at(index)
	
	if range(index, tokens_gui.size()).size() <= 0: return
	
	for i in range(index, tokens_gui.size()):
		tokens_gui[i].reparent(slots[i], false)
