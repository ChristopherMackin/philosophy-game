@tool
extends Node

class_name ViewportSuitTrack

@export_group("Packed Scene")
@export var token_gui_packed_scene : PackedScene
@export var token_slot_packed_scene : PackedScene

@export_group("Track Data")
@export var suit : Suit:
	set(val):
		suit = val
		update_color.call_deferred()
@export var slot_count : int:
	set(val):
		slot_count = val if val > 0 else 0
		refresh_slots.call_deferred()

@export_group("References")
@export var slot_parent : Control:
	set(val):
		slot_parent = val
		refresh_slots.call_deferred()	
@export var icon : TextureRect:
	set(val):
		icon = val
		update_color.call_deferred()

var slots : Array[Control]

func refresh_slots():
	for slot in slots:
		slot.queue_free()
	
	slots.clear()
	
	if !token_slot_packed_scene: return
	
	for i in slot_count:
		var slot = token_slot_packed_scene.instantiate()
		slot_parent.add_child(slot)
		slots.append(slot)
	
	update_color()

func update_color():
	if !suit: return
	
	for slot in slots: 
		slot.self_modulate = suit.color
	
	if icon:
		icon.texture = suit.icon
		icon.self_modulate = suit.color
