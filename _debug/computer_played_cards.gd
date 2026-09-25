extends NodeBasedDebateSubscriber

@export_category("Dependencies")
@export var card_ui_factory: CardUiFactory
@export var card_parent: Control

@export_category("Settings")
@export var seconds_before_start: float = .5
@export var seconds_between_cards: float = .2
@export var seconds_before_close: float = 2

func on_turn_end(contestant : Contestant):
	if contestant == manager.player: return
	self.visible = true
	
	await GlobalTimer.wait_for_seconds(seconds_before_start)
	
	for card in manager.blackboard.get_flag_value(Flag.TURN_CARD_HISTORY):
		var card_ui: CardUi = card_ui_factory.get_card_ui(card)
		card_ui.card = card
		card_parent.add_child(card_ui)
		await GlobalTimer.wait_for_seconds(seconds_between_cards)
	
	await GlobalTimer.wait_for_seconds(seconds_before_close)
	
	for child in card_parent.get_children():
		child.queue_free()
	
	self.visible = false
