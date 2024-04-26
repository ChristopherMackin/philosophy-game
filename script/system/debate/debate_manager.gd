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

var discard : Array[Card]

var current_card : Card:
	get: 
		return discard.back()
var current_suit : Suit:
	get: 
		return current_card.data.suit

var previous_card : Card:
	get: 
		return discard[discard.size() - 2] if discard.size() > 1 else null
var previous_suit : Suit:
	get: 
		return previous_card.data.suit

var topic_score_dictionary : Dictionary

var subscriber_array : Array[DebateSubscriber]

func subscribe(subscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(player_character : Character, computer_character : Character):
	for t : Topic in debate_settings.topic_array:
		topic_score_dictionary[t] = 0
	
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
	discard.append(await active_contestant.take_turn())
	active_contestant.clean_up()

func get_is_debate_over() -> bool:
	for key in topic_score_dictionary:
		var score = topic_score_dictionary[key]
		if abs(score) >= debate_settings.win_amount:
			return true
	
	for c : Contestant in contestants:
		if c.deck.count + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	while active_contestant.current_energy > 0 and !get_is_debate_over():
		discard.append(await active_contestant.take_turn())
		
		var suit_relation = debate_settings.get_suit_relationship(
			previous_suit, 
			current_suit
		)
		
		for sub : DebateSubscriber in subscriber_array: sub.on_card_played(current_card, active_contestant)
		
		increase_suit_score(current_suit, 1)
		
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
		
	active_contestant.clean_up()

func increase_suit_score(suit : Suit, amount : int):
	var topic = debate_settings.get_topic(suit)
	topic_score_dictionary[topic] += topic.suit_direction(suit) * amount
	for sub : DebateSubscriber in subscriber_array: sub.topic_score_updated(topic, topic_score_dictionary[topic])
