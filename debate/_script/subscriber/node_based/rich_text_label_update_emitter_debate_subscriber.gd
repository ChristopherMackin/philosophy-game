extends NodeBasedDebateSubscriber

class_name RichTextLableUpdateEmitterDebateSubscriber

@export var label: RichTextLableUpdateEmitter
@export var properties: Array[String]
@export_multiline var format: String

func on_debate_start(): update_label()

func on_turn_start(_contestant: Contestant): update_label()

func on_turn_end(_contestant: Contestant): update_label()

func on_card_played(_card: Card, _contestant : Contestant): update_label()

func on_token_played(_token: Token, _suit: Suit, _contestant : Contestant): update_label()

func on_lines_cleared(_count : int): update_label()

func on_debate_finished(): update_label()

func on_actions_invoked(_card : Card, _action_type: CardAction.Type, _contestant : Contestant): update_label()

func on_card_drawn(_card : Card, _contestant: Contestant): update_label()
	
func on_card_hold_updated(_card : Card, _active_contestant : Contestant): update_label()

func update_label(): 
	var val = format % properties.map(func(x): return str(manager.get_indexed(x)))
	label.update_label(val)
