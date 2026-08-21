extends NodeBasedDebateSubscriber

class_name EventQueryDebateSubscriber

@export var event_factory: EventFactory:
	get:
		if !event_factory:
			event_factory = EventFactory.new()
		return event_factory
@export var event_manager : EventManager

func _ready():
	super._ready()

func on_debate_start(): await query_event(Const.Concept.ON_DEBATE_START)

func on_turn_start(contestant: Contestant):await query_event(Const.Concept.ON_TURN_START)
	
func on_turn_end(contestant: Contestant): await query_event(Const.Concept.ON_TURN_END)

func on_card_played(card: Card, contestant : Contestant): await query_event(Const.Concept.ON_PLAY)

func on_token_played(token: Token, suit: Suit, contestant : Contestant): await query_event(Const.Concept.ON_TOKEN_PLAYED)
	
func on_card_hold_updated(card : Card, active_contestant : Contestant): await query_event(Const.Concept.ON_HOLD)

func on_lines_cleared(count : int): await query_event(Const.Concept.ON_LINES_CLEARED)

func on_actions_invoked(card : Card, action_type: CardAction.Type, contestant : Contestant): await query_event(Const.Concept.ON_ACTION_INVOKED)

func on_card_drawn(card : Card, contestant: Contestant): await query_event(Const.Concept.ON_CARD_DRAWN)

func on_debate_finished():
	print("Debate Finished")
	await query_event(Const.Concept.ON_DEBATE_END)

func query_event(concept : Const.Concept):
	var query : Dictionary
	query["concept"] = concept
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(event_manager.blackboard.get_query())
	
	var event = event_factory.get_event(query)
	
	if !event: return
	
	if event.await_event:
		await event_manager.start_event(event)
	else:
		event_manager.start_event(event)
