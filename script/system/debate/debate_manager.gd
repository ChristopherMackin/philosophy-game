extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings
@export var debate_state : StateDatabase

var player : Contestant:
	set(val):
		player = val
		debate_state.update_value("player", player.name)
var computer : Contestant:
	set(val):
		computer = val
		debate_state.update_value("computer", computer.name)

var event_factory : EventFactory:
	get: return computer.debate_event_factory

var active_contestant : Contestant:
	get: return active_contestant
	set(val):
		for sub : DebateSubscriber in subscriber_array: await sub.on_player_change(val)
		active_contestant = val
		var contestant = "player" if active_contestant == player else "computer"
		debate_state.update_value("active_contestant", contestant)

var inactive_contestant : Contestant:
	get:
		if player == active_contestant:
			return computer
		elif computer == active_contestant:
			return player
		else:
			return null

var contestants : Array[Contestant]

var card_stack : Array[Card]

var current_card : Card:
	get: 
		return card_stack.back() if card_stack.size() > 0 else null
var current_suit : Suit:
	get: 
		return current_card.data.suit if current_card else null

var previous_card : Card:
	get: 
		return card_stack[card_stack.size() - 2] if card_stack.size() > 1 else null
var previous_suit : Suit:
	get: 
		return previous_card.data.suit

var suit_score_dictionary : Dictionary

var subscriber_array : Array[DebateSubscriber]

var current_turn : int = 0:
	set(val): 
		current_turn = val
		debate_state.update_value("current_turn", current_turn)

func subscribe(subscriber : DebateSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : DebateSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(player_character : Character, computer_character : Character):
	debate_state.clear()
	for t : Topic in debate_settings.topic_array:
		for s : Suit in t.suits:
			suit_score_dictionary[s.name] = 0
	
	player = Contestant.new(player_character)
	computer = Contestant.new(computer_character)
	
	contestants.append(player)
	contestants.append(computer)
	
	for c in contestants:
		c.ready_up()
	
	active_contestant = computer
	
	game_loop()

func game_loop():
	await set_initial_card()
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_start(current_card)
	
	while !get_is_debate_over():
		current_turn += 1
		
		active_contestant = inactive_contestant
		await active_player_turn()
	
	var debates_finished = computer.memory.get_value("debates_finished")
	computer.memory.update_value("debates_finished", debates_finished + 1)
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_finished()

func set_initial_card():
	card_stack.append(await active_contestant.take_turn())
	update_db_with_card_stack()
	active_contestant.clean_up()

func get_is_debate_over() -> bool:
	for key in suit_score_dictionary:
		if (suit_score_dictionary[key]) >= debate_settings.win_amount:
			return true
	
	for c : Contestant in contestants:
		if c.deck.count + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	while active_contestant.current_energy > 0 and !get_is_debate_over():
		card_stack.append(await active_contestant.take_turn())
		update_db_with_card_stack()
		
		var suit_relation = debate_settings.get_suit_relationship(
			previous_suit, 
			current_suit
		)
		
		for sub : DebateSubscriber in subscriber_array: await sub.on_card_played(current_card, active_contestant)
		
		suit_score_dictionary[current_suit.name] += 1
		
		match suit_relation:
			DebateSettings.SuitRelationship.SAME:
				var action = current_card.data.action
				await action.positive_action(self);
				for sub : DebateSubscriber in subscriber_array: await sub.on_action_taken(action, true)
			DebateSettings.SuitRelationship.OPPOSING:
				var action = current_card.data.action
				await action.negative_action(self);
				for sub : DebateSubscriber in subscriber_array: await sub.on_action_taken(action, false)
			_:
				pass
		
	active_contestant.clean_up()

func get_debate_state() -> Dictionary:
	var state := debate_state.value
	state.merge(computer.memory.value)
	
	return state

func update_db_with_card_stack():
	debate_state.update_value("current_card", current_card.data.name if current_card else null)
	debate_state.update_value("current_suit", current_card.data.suit.name if current_card else null)
	debate_state.update_value("previous_card", previous_card.data.name if previous_card else null)
	debate_state.update_value("previous_suit", previous_card.data.suit.name if previous_card else null)
