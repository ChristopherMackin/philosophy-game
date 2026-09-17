extends NodeBasedDebateSubscriber

@export_category("Dependencies")
@export var card_ui_factory: CardUiFactoryBase
@export var card_parent: Control

@export_category("Settings")
@export var seconds_wait_time: float = 1

func on_card_played(card: Card, contestant : Contestant):
	if contestant == manager.player: return
	
	var card_ui: CardUi = card_ui_factory.get_card_ui(card).instantiate()
	card_ui.card = card
	card_parent.add_child(card_ui)
	await GlobalTimer.wait_for_seconds(seconds_wait_time)
	
	card_ui.queue_free()
	await GlobalTimer.wait_for_seconds(.2)
