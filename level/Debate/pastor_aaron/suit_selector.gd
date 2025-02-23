extends Panel

class_name SuitSelector

@export_group("Packed Scene")
@export var suit_banner_ui_suit_packed_scene : Array[SuitPackedScene]

@export_group("Layout")
@export var card_container : Container

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain

var ui_banners : Array[BannerUI]

func _ready():
	_clear_banners()

func _clear_banners():
	for child in card_container.get_children():
		child.queue_free()
	
	ui_banners.clear()

func _add_suit(suit : Suit):
	var index = suit_banner_ui_suit_packed_scene.map(func(x): return x.suit).find(suit)
	index = index if index >= 0 else 0
	var suit_banner_packed_scene = suit_banner_ui_suit_packed_scene[index].packed_scene
	
	var banner_ui : BannerUI = suit_banner_packed_scene.instantiate() as BannerUI
	#banner_ui.suit = suit
	#This has been left out because we can just set the suit before hand
	#This can also give us some really cool false choices in the future
	
	card_container.add_child(banner_ui)
	
	ui_banners.append(banner_ui)

func open_selector(suit_array : Array[Suit], visible_to_player : bool = true):
	for suit in suit_array:
		_add_suit(suit)
		
	Util.set_up_focus_connections.call_deferred(ui_banners)
	
	focus_group.focused_node = ui_banners[0]
	focus_group.on_select.connect(on_select)
	
	visible = true

func close_selector():
	visible = false
	_clear_banners()

func on_select(data, focus_type : String):
	player_brain.make_selection(data)
	focus_group.on_select.disconnect(on_select)
	close_selector()
