extends Resource

class_name DebateManager

var debate_settings : DebateSettings
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

var subscriber_array : Array[DebateSubscriber]

var current_turn : int = 0:
	set(val): 
		current_turn = val
		debate_state.update_value("current_turn", current_turn)

var top_queue_dictionary : Dictionary

func subscribe(subscriber : DebateSubscriber):
	subscriber_array.append(subscriber)

func unsubscribe(subscriber : DebateSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func init(player_character : Character, computer_character : Character, debate_settings : DebateSettings):
	
	self.debate_settings = debate_settings
	
	for pose in debate_settings.poses:
		top_queue_dictionary[pose.name] = []
	
	debate_state.clear()
	
	player = Contestant.new(player_character)
	computer = Contestant.new(computer_character)
	
	contestants.append(player)
	contestants.append(computer)
	
	for c in contestants:
		c.ready_up()
	
	active_contestant = computer
	
	game_loop()

func game_loop():
	while !get_is_debate_over():
		current_turn += 1
		
		active_contestant = inactive_contestant
		await active_player_turn()
	
	var debates_finished = computer.memory.get_value("debates_finished")
	computer.memory.update_value("debates_finished", debates_finished + 1)
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_finished()

func get_is_debate_over() -> bool:
	for value in top_queue_dictionary.values():
		if value.size() >= debate_settings.top_slots:
			return true
	
	for c : Contestant in contestants:
		if c.deck.count + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	while active_contestant.current_energy > 0 and !get_is_debate_over():
		var top = await active_contestant.take_turn()
		
		top_queue_dictionary[top.data.pose.name].append(top)
		
		for sub : DebateSubscriber in subscriber_array: await sub.on_top_played(top, active_contestant)
		
		top.data.action.invoke(self)
		
		clear_lines()
	
	active_contestant.clean_up()

func clear_lines():
	var min = top_queue_dictionary.values()[0].size()
	
	for value in top_queue_dictionary.values():
		if min > value.size():
			min = value.size()
	
	if min > 0:
		for key in top_queue_dictionary:
			var array = top_queue_dictionary[key] as Array
			for i in min:
				top_queue_dictionary.erase(top_queue_dictionary.keys()[i])
		for sub : DebateSubscriber in subscriber_array: await sub.on_lines_cleared(min)
