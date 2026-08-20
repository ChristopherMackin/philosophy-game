extends Control

class_name CardSelector

@export_group("Card Ui")
@export var card_ui_factory_base: CardUiFactoryBase

@export_group("Layout")
@export var card_container : Container

@export_group("Selection")
@export var focus_group : FocusGroup
@export var player_brain : PlayerBrain
@export var submit_button : Control

var cards_ui : Array[CardUi]
var selection_array : Array
var selection_callable : Callable

var amount: int
var min_amount: int

func _ready():
	_clear_card_container()
	focus_group.on_select.connect(on_select)

func _clear_card_container():
	for child in card_container.get_children():
		child.queue_free()
	
	cards_ui.clear()
	selection_array.clear()

func _add_card(card : Card):	
	var card_ui_packed_scene = card_ui_factory_base.get_card_ui(card)
	
	var card_ui : CardUi = card_ui_packed_scene.instantiate() as CardUi
	card_ui.card = card
	
	card_container.add_child(card_ui)
	
	cards_ui.append(card_ui)

func open_selector(cards : Array[Card], visible_to_player : bool, mode: Const.SelectionAction, amount: int = -1, min_amount: int = -1):
	for card in cards:
		_add_card(card)
	
	match mode:
		Const.SelectionAction.VIEW:
			submit_button.visible = true
			
			Util.set_up_focus_connections.call_deferred([submit_button])
			focus_group.focus(submit_button)
			
			selection_callable = select_view
		
		Const.SelectionAction.SELECT:
			self.amount = amount
			self.min_amount = min_amount if min_amount < cards.size() else cards.size()
			
			if amount == 1 and min_amount == 1:
				submit_button.visible = false
				
				Util.set_up_focus_connections.call_deferred(cards_ui)
				focus_group.focused_node = cards_ui[0]
				
				selection_callable = select_single
			else:
				submit_button.visible = true
			
				var focus_items : Array[Control] = []
				focus_items.append_array(cards_ui)
				focus_items.append(submit_button)
				Util.set_up_focus_connections.call_deferred(focus_items)
				focus_group.focused_node = cards_ui[0]
				
				for card_ui in cards_ui:
					card_ui.modulate = Color.GRAY
			
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
	if player_brain.make_selection(SelectionResponse.new([data])):
		close_selector()

func select_multi(data, what: String, focus_type : String):
	if focus_type == "submit":
		if min_amount != -1 or min_amount > selection_array.size(): return
		
		if player_brain.make_selection(SelectionResponse.new(selection_array)):
			close_selector()
	else:
		var card_ui_index = cards_ui.map(func(x): return x.card).find(data)
		var card_ui = cards_ui[card_ui_index]
		
		if selection_array.has(data):
			var index = selection_array.find(data)
			selection_array.remove_at(index)
			card_ui.modulate = Color.GRAY
		elif amount == -1 or selection_array.size() < amount:
			selection_array.append(data)
			card_ui.modulate = Color.WHITE
