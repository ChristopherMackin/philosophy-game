extends Resource

class_name DebateManager

var debate_settings : DebateSettings
@export var blackboard : Blackboard

var player : Contestant:
	set(val):
		player = val
var computer : Contestant:
	set(val):
		computer = val

var active_contestant : Contestant

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

@export var subscribers : Array = []

var current_turn : int = 0

var current_round : int:
	get: return floor(current_turn / 2)

var lines_cleared : int = 0

var suit_track_dictionary : Dictionary

var play_stack : CardCollection = CardCollection.new()

func subscribe(subscriber):
	subscribers.append(subscriber)

func unsubscribe(subscriber):
	var index = subscribers.find(subscriber)
	
	if index != -1:
		subscribers.remove_at(index)

func init(player_character : Character, computer_character : Character, debate_settings : DebateSettings):
	
	for subscriber in subscribers:
		subscriber.manager = self
	
	self.debate_settings = debate_settings
	
	for suit in debate_settings.suits:
		var suit_array : Array[Token] = []
		suit_track_dictionary[suit.name] = suit_array
	
	play_stack.on_added.add_listener(func(card: Card): await card.on_play(card_player, self))
	play_stack.on_added.add_listener(func(card: Card): 
		for sub in subscribers: await sub.on_card_played(card, card_player)
	)
	
	player = Contestant.new(player_character, self)
	computer = Contestant.new(computer_character, self)
	
	contestants.append(player)
	contestants.append(computer)
	
	for contestant in contestants:
		await contestant.ready_up()
	
	for sub in subscribers: await sub.on_debate_start()
	
	blackboard.expire(Blackboard.ExpirationToken.ON_DEBATE_START)
	
	game_loop()

func game_loop():
	current_turn = 1
	active_contestant = player if debate_settings.starting_player == Const.Player.HUMAN else computer
	await active_player_turn()
	
	while !get_is_debate_over():
		current_turn += 1
		active_contestant = inactive_contestant
		await active_player_turn()
		
	for sub in subscribers: await sub.on_debate_finished()

func get_is_debate_over() -> bool:
	for condition in debate_settings.game_end_conditions:
		if condition.check_condition(self): return true
	
	return false

func active_player_turn():
	await active_contestant.start_turn()
	for sub in subscribers: await sub.on_turn_start(active_contestant)
	
	while active_contestant.can_play and !get_is_debate_over():
		var response = await active_contestant.take_turn()
		var card = response.data
		
		if response.what == "play":
			active_contestant.current_energy -= card.cost
			
			var token = card.pop_token()
			if token:
				await play_token(token, card.suit, active_contestant)
			
			await play_card(card, active_contestant)
		
		active_contestant.phase_end()
		
		clear_lines()
	
	await active_contestant.end_turn()
	for sub in subscribers: await sub.on_turn_end(active_contestant)

func play_token(token : Token, suit : Suit, contestant : Contestant):
	await add_token_to_suit_track(token, suit)
	for sub in subscribers: await sub.on_token_played(token, suit, contestant)

func play_card(card : Card, contestant : Contestant):
	card_player = contestant
	await play_stack.push_front(card)
	
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
		
		lines_cleared += min
		for sub in subscribers: await sub.on_lines_cleared(min)



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
