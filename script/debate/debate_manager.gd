extends Resource

class_name DebateManager

var debate_settings : DebateSettings
@export var blackboard : Blackboard

var player : Contestant:
	set(val):
		player = val
		blackboard.add("player", player.name, Const.ExpirationToken.ON_DEBATE_START)
var computer : Contestant:
	set(val):
		computer = val
		blackboard.add("computer", computer.name, Const.ExpirationToken.ON_DEBATE_START)

var active_contestant : Contestant:
	get: return active_contestant
	set(val):
		active_contestant = val
		var contestant = "player" if active_contestant == player else "computer"
		blackboard.add("active_contestant", contestant, Const.ExpirationToken.ON_DEBATE_START)

var inactive_contestant : Contestant:
	get:
		if player == active_contestant:
			return computer
		elif computer == active_contestant:
			return player
		else:
			return null

var card_player : Contestant

var contestants : Array[Contestant]

var subscriber_array : Array[DebateSubscriber]

var current_turn : int = 0:
	set(val): 
		current_turn = val
		blackboard.add("current_turn", current_turn, Const.ExpirationToken.ON_DEBATE_START)
		blackboard.add("current_round", current_round, Const.ExpirationToken.ON_DEBATE_START)

var current_round : int:
	get: return floor(current_turn / 2)

var suit_track_dictionary : Dictionary

var play_stack : CardCollection = CardCollection.new()

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
	
	play_stack.on_added.add_listener(func(card: Card): await card.on_play(card_player, self))
	play_stack.on_added.add_listener(func(card: Card): 
		for sub : DebateSubscriber in subscriber_array: await sub.on_card_played(card, card_player)
	)
	
	player = Contestant.new(player_character, self)
	computer = Contestant.new(computer_character, self)
	
	contestants.append(player)
	contestants.append(computer)
	
	for contestant in contestants:
		await contestant.ready_up()
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_start()
	
	blackboard.expire(Const.ExpirationToken.ON_DEBATE_START)
	
	game_loop()

func game_loop():
	current_turn = 1
	active_contestant = player if debate_settings.starting_player == Const.Player.HUMAN else computer
	for sub : DebateSubscriber in subscriber_array: await sub.on_player_change(active_contestant)
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
		if c.draw_pile.size() + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	await active_contestant.start_turn()
	for sub : DebateSubscriber in subscriber_array: await sub.on_turn_start(active_contestant)
	
	while active_contestant.can_play and !get_is_debate_over():
		var response = await active_contestant.take_turn()
		var card = response.data
		
		if response.what == "play":
			active_contestant.current_energy -= card.cost
		
			blackboard.add("previous_card", blackboard.get_value("current_card"), Const.ExpirationToken.ON_DEBATE_START)
			blackboard.add("current_card", card, Const.ExpirationToken.ON_DEBATE_START)
			
			var token = card.pop_token()
			if token:
				await play_token(token, card.suit, active_contestant)
			
			await play_card(card, active_contestant)
		
		if debate_settings.redraw_on_hand_depleted && active_contestant.hand.size() <= 0:
			await active_contestant.draw_full_hand()
		
		clear_lines()
	
	await active_contestant.end_turn()
	for sub : DebateSubscriber in subscriber_array: await sub.on_turn_end(active_contestant)

func play_token(token : Token, suit : Suit, contestant : Contestant):
	await add_token_to_suit_track(token, suit)
	for sub : DebateSubscriber in subscriber_array: await sub.on_token_played(token, suit, contestant)

func play_card(card : Card, contestant : Contestant):
	card_player = contestant
	await play_stack.push_back(card)
	
func clear_lines():
	var min = suit_track_dictionary.values()[0].size()
	
	for value in suit_track_dictionary.values():
		if min > value.size():
			min = value.size()
	
	if min > 0:
		for key in suit_track_dictionary:
			var array = suit_track_dictionary[key] as Array
			for i in min:
				if debate_settings.line_clear_direction == Const.Direction.RIGHT:
					array.remove_at(array.size() - 1)
				else:
					array.remove_at(0)
		for sub : DebateSubscriber in subscriber_array: await sub.on_lines_cleared(min)



func remove_at_from_suit_track(suit : Suit, index : int):
	if suit_track_dictionary.size() <= index: return
	suit_track_dictionary[suit.name].remove_at(index)

func pop_from_suit_track(suit : Suit) -> Token:
	return suit_track_dictionary[suit.name].pop_back()

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

func get_opponent(contestant : Contestant):
	return computer if contestant == player else player

func add_token_to_suit_track(token : Token, suit : Suit):
	if suit_track_dictionary.has(suit.name):
		suit_track_dictionary[suit.name].append(token)
