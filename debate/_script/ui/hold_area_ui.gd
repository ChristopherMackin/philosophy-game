extends NodeBasedDebateSubscriber

class_name HoldAreaUi

@export var card_ui_factory_base: CardUiFactoryBase
@export var card_parent: Node
@export var animation_player: AnimationPlayer

var held_card : CardUi = null

func set_hold_card(card: Card):
	if held_card && held_card.card == card: return
	
	if held_card:
		await remove_card()
	
	if card != null:
		add_card(card)

func remove_card():
	animation_player.play("card_exit")
	await animation_player.animation_finished
	
	held_card.queue_free()
	held_card = null

func add_card(card):
	var card_ui_packed_scene = card_ui_factory_base.get_card_ui(card)
	
	var card_ui : CardUi = card_ui_packed_scene.instantiate() as CardUi
	card_parent.add_child(card_ui)
	
	card_ui.card = card
	card_ui.set_anchors_preset(Control.PRESET_CENTER, true)
	
	held_card = card_ui
	
	animation_player.play("card_enter")
	await animation_player.animation_finished

func on_card_hold_updated(card : Card, active_contestant : Contestant):
	if active_contestant == manager.player:
		set_hold_card(card)
