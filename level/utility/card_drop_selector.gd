extends Control

class_name CardDropSelector

@export_group("Packed Scene")
@export var default_card_gui_packed_scene: PackedScene
@export var default_tokenless_card_gui_packed_scene: PackedScene

@export var card_gui_suit_packed_scenes : Array[SuitPackedScene]
@export var tokenless_card_gui_suit_packed_scenes : Array[SuitPackedScene]

@export_group("Selection")
@export var card_amount: int = 3
@export var card_parent: Control
@export var focus_group: FocusGroup
@export var card_slot_size : Vector2 = Vector2(370, 320)

@export_group("References")
@export var card_drop_table: CardDropTable
@export var deck: Deck

var cards_gui : Array[CardGUI]
var card_slots : Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in card_amount:
		var card = Card.new(card_drop_table.get_random_card(), null)
		var card_slot : Control = Control.new()
		card_slot.custom_minimum_size = card_slot_size
		
		var card_gui_packed_scene = get_card_gui_packed_scene(card)
		
		var card_gui : CardGUI = card_gui_packed_scene.instantiate() as CardGUI
		card_gui.card = card
		
		card_slot.add_child(card_gui)	
		card_parent.add_child(card_slot)
		
		card_gui.scale = Vector2(.81, .81)
		
		cards_gui.append(card_gui)
		card_slots.append(card_slot)
	
	focus_group.on_select.connect(on_select)
	
	(func():
		Util.set_up_focus_connections(cards_gui)
		focus_group.focus(cards_gui[0])
		focus_group.focused_node.grab_focus()
	).call_deferred()
	
	get_viewport().gui_focus_changed.connect(on_focus_changed)

func on_focus_changed(node : Node):
	if node is Control:
		node.grab_focus()
	
	focus_group.focus(node)

func _unhandled_input(event):
	if Input.is_action_just_pressed("action_1"):
		focus_group.select()

func on_select(data, what, type):
	if data == null: return
	deck.add_to_deck(data)
	SceneManager.replace_scene_async("aaron_db01_debate")

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
