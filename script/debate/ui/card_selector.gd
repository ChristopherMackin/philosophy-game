extends Control

class_name CardSelector

@export_group("Packed Scene")
@export var default_card_gui_packed_scene: PackedScene
@export var default_tokenless_card_gui_packed_scene: PackedScene

@export var card_gui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_gui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Layout")
@export var card_container : Container
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain
@export var submit_button : Control

var cards_gui : Array[CardGUI]
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
	cards_gui.clear()
	selection_array.clear()

func _add_card(card : Card):
	var card_slot : Control = Control.new()
	card_slot.custom_minimum_size = card_slot_size
	
	var card_gui_packed_scene = get_card_gui_packed_scene(card)
	
	var card_gui : CardGUI = card_gui_packed_scene.instantiate() as CardGUI
	card_gui.card = card
	
	card_slot.add_child(card_gui)	
	card_container.add_child(card_slot)
	
	card_gui.scale = Vector2(.81, .81)
	
	cards_gui.append(card_gui)
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
			
			Util.set_up_focus_connections.call_deferred(cards_gui)
			focus_group.focused_node = cards_gui[0]
			
			selection_callable = select_single
		
		Const.SelectionAction.MULTI:
			submit_button.visible = true
			
			var focus_items : Array[Control] = []
			focus_items.append_array(cards_gui)
			focus_items.append(submit_button)
			Util.set_up_focus_connections.call_deferred(focus_items)
			focus_group.focused_node = cards_gui[0]
			
			for card_gui in cards_gui:
				card_gui.modulate = Color.GRAY
			
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
		var card_gui_index = cards_gui.map(func(x): return x.card).find(data)
		var card_gui = cards_gui[card_gui_index]
		
		if selection_array.has(data):
			var index = selection_array.find(data)
			selection_array.remove_at(index)
			card_gui.modulate = Color.GRAY
		else:
			selection_array.append(data)
			card_gui.modulate = Color.WHITE

func get_card_gui_packed_scene(card: Card) -> PackedScene:
	var card_gui_packed_scene
	
	if card.has_token_base:
		var index = card_gui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_gui_packed_scene = default_card_gui_packed_scene
		else:
			card_gui_packed_scene = card_gui_suit_packed_scenes[index].packed_scene
	else:
		var index = tokenless_card_gui_suit_packed_scenes.map(func(x): return x.suit).find(card.suit)
		if index < 0:
			card_gui_packed_scene = default_tokenless_card_gui_packed_scene
		else:
			card_gui_packed_scene = tokenless_card_gui_suit_packed_scenes[index].packed_scene
	
	return card_gui_packed_scene
