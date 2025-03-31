extends Control

class_name CardSelector

@export_group("Packed Scene")
@export var default_card_ui_packed_scene: PackedScene
@export var default_tokenless_card_ui_packed_scene: PackedScene

@export var card_ui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_ui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Layout")
@export var card_container : Container
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain
@export var submit_button : Control

var ui_cards : Array[CardUI]
var card_slots : Array[Control]
var selection_array : Array
var selection_callable : Callable

func _ready():
	_clear_card_container()
	focus_group.on_select.connect(on_select)

func _clear_card_container():
	for child in card_container.get_children():
		child.queue_free()
	
	card_slots.clear()
	ui_cards.clear()
	selection_array.clear()

func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var card_ui_packed_scene = get_card_ui_packed_scene(card)
	
	var card_ui : CardUI = card_ui_packed_scene.instantiate() as CardUI
	card_ui.card = card
	
	card_slot.add_child(card_ui)	
	card_container.add_child(card_slot)
	
	card_ui.scale = Vector2(.81, .81)
	
	ui_cards.append(card_ui)
	card_slots.append(card_slot)

func open_selector(cards : Array[Card], visible_to_player : bool, mode : Const.SelectionAction):
	for card in cards:
		_add_card(card)
	
	match mode:
		Const.SelectionAction.VIEW:
			submit_button.visible = true
			
			Util.set_up_focus_connections.call_deferred([submit_button])
			focus_group.focus(submit_button)
			
			selection_callable = select_view
		
		Const.SelectionAction.SINGLE:
			submit_button.visible = false
			
			Util.set_up_focus_connections.call_deferred(ui_cards)
			focus_group.focused_node = ui_cards[0]
			
			selection_callable = select_single
		
		Const.SelectionAction.MULTI:
			submit_button.visible = true
			
			var focus_items : Array[Control] = []
			focus_items.append_array(ui_cards)
			focus_items.append(submit_button)
			Util.set_up_focus_connections.call_deferred(focus_items)
			focus_group.focused_node = ui_cards[0]
			
			for ui_card in ui_cards:
				ui_card.modulate = Color.GRAY
			
			selection_callable = select_multi
			
	visible = true

func close_selector():
	visible = false
	_clear_card_container()

func on_select(data, what: String, focus_type : String):
	if what == "play": selection_callable.call(data, what, focus_type)

func select_view(data, what: String, focus_type : String):
	player_brain.make_selection(null)
	close_selector()

func select_single(data, what: String, focus_type : String):
	if player_brain.make_selection(SelectionResponse.new(data)):
		close_selector()

func select_multi(data, what: String, focus_type : String):
	if focus_type == "submit":
		if player_brain.make_selection(SelectionResponse.new(selection_array)):
			close_selector()
	else:
		var ui_card_index = ui_cards.map(func(x): return x.card).find(data)
		var ui_card = ui_cards[ui_card_index]
		
		if selection_array.has(data):
			var index = selection_array.find(data)
			selection_array.remove_at(index)
			ui_card.modulate = Color.GRAY
		else:
			selection_array.append(data)
			ui_card.modulate = Color.WHITE

func get_card_ui_packed_scene(card: Card) -> PackedScene:
	var card_ui_packed_scene
	
	if card.has_token_base:
		var index = card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_ui_packed_scene = default_card_ui_packed_scene
		else:
			card_ui_packed_scene = card_ui_suit_packed_scenes[index].packed_scene
	else:
		var index = tokenless_card_ui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_ui_packed_scene = default_tokenless_card_ui_packed_scene
		else:
			card_ui_packed_scene = tokenless_card_ui_suit_packed_scenes[index].packed_scene
	
	return card_ui_packed_scene
