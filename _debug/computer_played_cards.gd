extends NodeBasedDebateSubscriber

@export_category("Dependencies")
@export var card_ui_factory: CardUiFactory
@export var card_parent: Control
@export var spawn_origin: Control
@export var card_slot_size: Vector2 = Vector2(250, 350)

@export_category("Settings")
@export var seconds_before_start: float = .5
@export var seconds_between_cards: float = .2
@export var seconds_before_close: float = 2

func on_turn_end(contestant : Contestant):
	var cards_slots: Array[Tuple]
	
	if contestant == manager.player: return
	self.visible = true
	
	await GlobalTimer.wait_for_seconds(seconds_before_start)
	
	var cards: Array[Card]
	cards.assign(manager.blackboard.get_flag_value(Flag.TURN_CARD_HISTORY))
	cards.reverse()
	
	var tween
	
	for card in cards:
		var slot = Control.new()
		card_parent.add_child(slot)
		slot.custom_minimum_size = card_slot_size
		
		var card_ui: CardUi = card_ui_factory.get_card_ui(card)
		card_ui.card = card
		spawn_origin.add_child(card_ui)
		card_ui.offset_transform_enabled = true
		card_ui.offset_transform_rotation = deg_to_rad(180)
		
		var tuple = Tuple.new(slot, card_ui)
		cards_slots.append(tuple)
		
		await GlobalTimer.wait_for_seconds(.01)
		
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		
		for t in cards_slots:
			tween.parallel().tween_property(t.val2, "global_position", t.val1.global_position, seconds_between_cards)
			tween.parallel().tween_property(t.val2, "offset_transform_rotation", 0, seconds_between_cards)
		
		await tween.finished
		tween.kill()
	
	await GlobalTimer.wait_for_seconds(seconds_before_close)
	
	for child in card_parent.get_children():
		child.queue_free()
	
	for child in spawn_origin.get_children():
		child.queue_free()
	
	self.visible = false
