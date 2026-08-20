extends Control

class_name SuitSelector

@export_group("Packed Scene")
@export var suit_banner_ui_suit_packed_scene : Array[SuitPackedScene]

@export_group("Layout")
@export var card_container : Container

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var banners_ui : Array[BannerUi]

func _ready():
	_clear_banners()

func _clear_banners():
	for child in card_container.get_children():
		child.queue_free()
	
	banners_ui.clear()

func _add_suit(suit : Suit):
	var index = suit_banner_ui_suit_packed_scene.map(func(x): return x.suit).find(suit)
	index = index if index >= 0 else 0
	var suit_banner_packed_scene = suit_banner_ui_suit_packed_scene[index].packed_scene
	
	var banner_ui : BannerUi = suit_banner_packed_scene.instantiate() as BannerUi
	#banner_ui.suit = suit
	#This has been left out because we can just set the suit before hand
	#This can also give us some really cool false choices in the future
	
	card_container.add_child(banner_ui)
	
	banners_ui.append(banner_ui)

func open_selector(suit_array : Array[Suit], visible_to_player : bool = true):
	for suit in suit_array:
		_add_suit(suit)
		
	Util.set_up_focus_connections.call_deferred(banners_ui)
	
	focus_group.focused_node = banners_ui[0]
	focus_group.on_select.connect(on_select)
	
	visible = true

func close_selector():
	visible = false
	_clear_banners()

func on_select(data, what, focus_type : String):
	if what != "play":
		return
	
	if player_brain.make_selection(SelectionResponse.new(data, what)):
		focus_group.on_select.disconnect(on_select)
		close_selector()
