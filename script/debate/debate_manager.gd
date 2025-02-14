extends Resource

class_name DebateManager

var debate_settings : DebateSettings
@export var blackboard : Blackboard

var player : Contestant:
	set(val):
		player = val
		blackboard.add("player", player.name, Constants.ExpirationToken.ON_DEBATE_START)
var computer : Contestant:
	set(val):
		computer = val
		blackboard.add("computer", computer.name, Constants.ExpirationToken.ON_DEBATE_START)

var active_contestant : Contestant:
	get: return active_contestant
	set(val):
		active_contestant = val
		var contestant = "player" if active_contestant == player else "computer"
		blackboard.add("active_contestant", contestant, Constants.ExpirationToken.ON_DEBATE_START)

var inactive_contestant : Contestant:
	get:
		if player == active_contestant:
			return computer
		elif computer == active_contestant:
			return player
		else:
			return null

var contestants : Array[Contestant]

var subscriber_array : Array[DebateSubscriber]

var current_turn : int = 0:
	set(val): 
		current_turn = val
		blackboard.add("current_turn", current_turn, Constants.ExpirationToken.ON_DEBATE_START)

var suit_track_dictionary : Dictionary

func subscribe(subscriber : DebateSubscriber):
	subscriber_array.append(subscriber)

func unsubscribe(subscriber : DebateSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(player_character : Character, computer_character : Character, debate_settings : DebateSettings):
	
	self.debate_settings = debate_settings
	
	for suit in debate_settings.suits:
		var suit_array : Array[Token] = []
		suit_track_dictionary[suit.name] = suit_array
	
	player = Contestant.new(player_character)
	computer = Contestant.new(computer_character)
	
	contestants.append(player)
	contestants.append(computer)
	
	for contestant in contestants: 
		contestant.on_hand_updated.connect(on_hand_updated)
		contestant.on_energy_updated.connect(on_energy_updated)
		contestant.on_deck_updated.connect(on_deck_updated)
		contestant.ready_up(self)

	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_start()
	
	blackboard.expire(Constants.ExpirationToken.ON_DEBATE_START)
	
	game_loop()

func game_loop():
	current_turn = 1
	active_contestant = player
	await active_player_turn()
	
	while !get_is_debate_over():
		current_turn += 1
		active_contestant = inactive_contestant
		for sub : DebateSubscriber in subscriber_array: await sub.on_player_change(active_contestant)
		await active_player_turn()
	
	if !computer.character.can_recall("debates_finished"):
		computer.character.remember("debates_finished", 1)
	else:
		var debates_finished = computer.character.recall("debates_finished")
		computer.character.remember("debates_finished", debates_finished + 1)
		
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_finished()

func get_is_debate_over() -> bool:
	for value in suit_track_dictionary.values():
		if value.size() >= debate_settings.slots:
			return true
	
	for c : Contestant in contestants:
		if c.get_draw_pile_count() + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	for card : Card in active_contestant.hand.duplicate():
		for action in card.data.on_turn_start_card_action:
			await action.invoke(card, active_contestant, self)
	
	while active_contestant.current_energy > 0 and !get_is_debate_over():
		var playable_cards = active_contestant.get_playable_cards()
		
		if playable_cards.size() <= 0:
			break
		
		var card = await active_contestant.select(playable_cards)
		var token = Token.new(card.data.token_data)
		
		active_contestant.current_energy -= card.data.get_cost(self)
		
		blackboard.add("previous_card", blackboard.get_value("current_card"), Constants.ExpirationToken.ON_DEBATE_START)
		blackboard.add("previous_suit", blackboard.get_value("current_suit"), Constants.ExpirationToken.ON_DEBATE_START)
		blackboard.add("current_card", card.data.title, Constants.ExpirationToken.ON_DEBATE_START)
		blackboard.add("current_suit", card.data.suit.name, Constants.ExpirationToken.ON_DEBATE_START)
		
		await add_token_to_suit_track(token, card.data.suit)
		
		await active_contestant.play_card(card)
		for sub : DebateSubscriber in subscriber_array: await sub.on_card_played(card, active_contestant)
		
		clear_lines()
	
	for card : Card in active_contestant.hand.duplicate():
		for action in card.data.on_turn_end_card_action:
			await action.invoke(card, active_contestant, self)
	
	active_contestant.clean_up()

func clear_lines():
	var min = suit_track_dictionary.values()[0].size()
	
	for value in suit_track_dictionary.values():
		if min > value.size():
			min = value.size()
	
	if min > 0:
		for key in suit_track_dictionary:
			var array = suit_track_dictionary[key] as Array
			for i in min:
				array.remove_at(0)
		for sub : DebateSubscriber in subscriber_array: await sub.on_lines_cleared(min)

func remove_token_from_suit_track(token : Token):
	var index
	var suit_name
	
	for key in suit_track_dictionary:
		index = suit_track_dictionary[key].find(token)
		if index >= 0: 
			suit_name = key
			break
	
	if index < 0: return
	
	suit_track_dictionary[suit_name].remove_at(index)
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_suit_track_updated(suit_track_dictionary)

func on_hand_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_hand_updated(contestant)

func on_energy_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_energy_updated(contestant)

func on_deck_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_deck_updated(contestant)

func get_opponent(contestant : Contestant):
	return computer if contestant == player else player

func add_token_to_suit_track(token : Token, suit : Suit):
	suit_track_dictionary[suit.name].append(token)
	for sub : DebateSubscriber in subscriber_array: await sub.on_suit_track_updated(suit_track_dictionary)
