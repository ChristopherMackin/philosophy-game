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
var top_history : Array[Top]

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
	
	for contestant in contestants: 
		contestant.on_hand_updated.connect(on_hand_updated)
		contestant.on_energy_updated.connect(on_energy_updated)
		contestant.on_deck_updated.connect(on_deck_updated)
	
	for c in contestants:
		c.ready_up(self)
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_start()
	
	active_contestant = computer
	for sub : DebateSubscriber in subscriber_array: await sub.on_player_change(active_contestant)
	
	game_loop()

func game_loop():
	while !get_is_debate_over():
		current_turn += 1
		
		active_contestant = inactive_contestant
		for sub : DebateSubscriber in subscriber_array: await sub.on_player_change(active_contestant)
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
		
		push_top_to_queue(top)
		
		for sub : DebateSubscriber in subscriber_array: await sub.on_top_played(top, active_contestant)
		
		top.data.action.invoke()
		
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
				array.remove_at(0)
		for sub : DebateSubscriber in subscriber_array: await sub.on_lines_cleared(min)

func get_debate_state() -> Dictionary:
	return Util.build_query([
		debate_state,
		computer.memory,
	])

func push_top_to_queue(top : Top):
	debate_state.update_value("previous_top", debate_state.get_value("current_top"))
	debate_state.update_value("previous_pose", debate_state.get_value("current_pose"))
	
	top_queue_dictionary[top.data.pose.name].append(top)
	top_history.append(top)
	
	debate_state.update_value("current_top", top.data.title)
	debate_state.update_value("current_pose", top.data.pose.name)

func on_hand_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_hand_updated(contestant)

func on_energy_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_energy_updated(contestant)

func on_deck_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_deck_updated(contestant)
