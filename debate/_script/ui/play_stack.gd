extends NodeBasedDebateSubscriber

class_name PlayStack

@export var offset: Vector3
@export var card_ui_factory: CardUiFactory
@export var card_3d: PackedScene
@export var seconds_between_play: float = .2

var cards_3d: Array[Card3d] = []

func _add_card_to_play_stack(card):
	var instance: Card3d = card_3d.instantiate()
	add_child(instance)
	var card_ui = card_ui_factory.get_card_ui(card)
	instance.init(card, card_ui)
	instance.position += offset * cards_3d.size()
	cards_3d.append(instance)

func on_card_played(card: Card, contestant : Contestant):
	if contestant != manager.player: return
	_add_card_to_play_stack(card)

func on_turn_end(contestant: Contestant):
	if contestant != manager.computer: return
	var callable = func():
		for card in manager.blackboard.get_flag_value(Flag.TURN_CARD_HISTORY):
			_add_card_to_play_stack(card)
			await GlobalTimer.wait_for_seconds(seconds_between_play)
	
	callable.call()
