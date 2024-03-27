@tool
extends Node2D

class_name HandUI

@export var container_width : float
@export var preferred_margin : float = 0

@export var player_brain : PlayerBrain

@export var SameContainer : FanSpriteContainer
@export var OpposingContainer : FanSpriteContainer
@export var OffTopicContainer : FanSpriteContainer

@export var debate_settings : DebateSettings

var ui_card_array : Array = []

@export var card_prefab : PackedScene

var _orgainze : bool = false

signal animation_finished

func _process(delta):
	if _orgainze:
		organize_children()
		_orgainze = false

func queue_orgainze():
	_orgainze = true

func is_enabled(val : bool):
	for child in get_children():
		child.set_process(val)

func on_card_played(card : Card):
	var cards = ui_card_array.map(func(x): return x.card)
	var index = cards.find(card)
	var element = ui_card_array.pop_at(index)
	element.queue_free()

func add_cards(added_cards : Array):
	for card in added_cards:
		var ui_card : UICard = card_prefab.instantiate()
		
		var index : int = ui_card_array.size()
		var on_click : Callable = func() : player_brain.play_card(card)
		
		ui_card.initialize(card, on_click)
		
		ui_card_array.append(ui_card)

func update_card_array(hand_card_array : Array, current_suit: Suit):
	var to_add_array = hand_card_array.duplicate();
	
	for ui_card : UICard in ui_card_array.duplicate():
		var index = hand_card_array.find(ui_card.card)
		
		if index == -1:
			var i = ui_card_array.find(ui_card)
			ui_card_array.pop_at(i).queue_free()
		else:
			var card = hand_card_array[index]
			var i = to_add_array.find(card)
			to_add_array.remove_at(i)
	
	add_cards(to_add_array)
	orgainze_cards(current_suit)

func orgainze_cards(suit : Suit):
	if suit == null:
		return
	
	for ui_card : UICard in ui_card_array:
		var relationship = debate_settings.get_suit_relationship(suit, ui_card.card.data.suit)
		
		match relationship:
			DebateSettings.SuitRelationship.SAME:
				if ui_card.get_parent():
					ui_card.reparent(SameContainer, true)
				else:
					SameContainer.add_child(ui_card)
			DebateSettings.SuitRelationship.OPPOSING:
				if ui_card.get_parent():
					ui_card.reparent(OpposingContainer, true)
				else:
					OpposingContainer.add_child(ui_card)
			DebateSettings.SuitRelationship.OFF_TOPIC:
				if ui_card.get_parent():
					ui_card.reparent(OffTopicContainer, true)
				else:
					OffTopicContainer.add_child(ui_card)

func organize_children():
	var children = []
	
	for child : FanSpriteContainer in get_children():
		if(child.actual_width > 0):
			children.append(child)
	
	var n = children.size()
	
	if n <= 1:
		for child in children:
			child.position = Vector2(0,0)
		return
	
	var combined_width = 0
	
	for c : FanSpriteContainer in children:
		combined_width += c.actual_width
	
	var margin_count : int = n - 1
	
	var total_width = combined_width + (margin_count * preferred_margin)
	var margin = preferred_margin
	
	if total_width > container_width:
		total_width = container_width
		margin = (container_width - combined_width) / margin_count
	
	var pos = total_width / -2
		
	for c : FanSpriteContainer in children:
		var width = c.actual_width
		
		c.position = Vector2(pos + width / 2, 0)
		
		pos += width + margin
