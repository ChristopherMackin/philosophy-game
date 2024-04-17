extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var player : Contestant
var computer : Contestant

var active_contestant : Contestant:
	get: return active_contestant
	set(val):
		for sub : DebateSubscriber in subscriber_array: sub.on_player_change(val)
		active_contestant = val

var inactive_contestant : Contestant:
	get:
		if player == active_contestant:
			return computer
		elif computer == active_contestant:
			return player
		else:
			return null

var contestants : Array[Contestant]

var current_card : Card
var current_suit : Suit:
	get: return current_card.data.suit

var topic_score_float_array : Array[float]
var current_topic_index : int

var current_topic : Topic:
	get:
		return debate_settings.topic_array[current_topic_index]
var current_topic_score: float:
	get: return topic_score_float_array[current_topic_index]
	set(val):
		topic_score_float_array[current_topic_index] = val

var subscriber_array : Array[DebateSubscriber]

func subscribe(subscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(player_character : Character, computer_character : Character):
	for i in debate_settings.topic_array.size():
		topic_score_float_array.append(0)
	
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
	active_contestant = inactive_contestant
	for sub : DebateSubscriber in subscriber_array: sub.on_debate_start(current_card)
	
	while not get_is_debate_over():
		await active_player_turn()
		active_contestant = inactive_contestant
	
	for sub : DebateSubscriber in subscriber_array: sub.on_debate_finished()

func set_initial_card():
	current_card = await active_contestant.take_turn()
	current_topic_index = debate_settings.get_topic_index(current_suit)

func get_is_debate_over() -> bool:
	for score in topic_score_float_array:
		if abs(score) >= debate_settings.win_amount:
			return true
	
	return false

func active_player_turn():
	var previous_card = current_card
	current_card = await active_contestant.take_turn()
	
	var suit_relation = debate_settings.get_suit_relationship(
		previous_card.data.suit, 
		current_suit
	)
	
	current_topic_index = debate_settings.get_topic_index(current_suit)
	current_topic_score += current_topic.suit_direction(current_suit)
	
	for sub : DebateSubscriber in subscriber_array: sub.on_card_played(current_card, active_contestant)
	
	match suit_relation:
		DebateSettings.SuitRelationship.SAME:
			var action = current_card.data.action
			await action.positive_action(self);
			for sub : DebateSubscriber in subscriber_array: sub.on_action_taken(action, true)
		DebateSettings.SuitRelationship.OPPOSING:
			var action = current_card.data.action
			await action.negative_action(self);
			for sub : DebateSubscriber in subscriber_array: sub.on_action_taken(action, false)
		_:
			pass
	
	active_contestant.draw_full_hand()

func increase_suit_score(suit : Suit, amount : int):
	pass
