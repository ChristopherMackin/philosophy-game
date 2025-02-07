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

var pose_track_dictionary : Dictionary
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
		var pose_array : Array[Top] = []
		pose_track_dictionary[pose.name] = pose_array
	
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
	
	var debates_finished = computer.recall("debates_finished")
	computer.remember("debates_finished", debates_finished + 1)
	for sub : DebateSubscriber in subscriber_array: await sub.on_debate_finished()

func get_is_debate_over() -> bool:
	for value in pose_track_dictionary.values():
		if value.size() >= debate_settings.top_slots:
			return true
	
	for c : Contestant in contestants:
		if c.deck.count + c.hand.size() <= 0:
			return true
	
	return false

func active_player_turn():
	while active_contestant.current_energy > 0 and !get_is_debate_over():
		var playable_tops = active_contestant.get_playable_tops()
		
		var top = await active_contestant.select_top(playable_tops)
		
		active_contestant.discard_top(top)
		active_contestant.current_energy -= top.data.cost
		
		await play_top(top)
		
		clear_lines()
	
	active_contestant.clean_up()

func clear_lines():
	var min = pose_track_dictionary.values()[0].size()
	
	for value in pose_track_dictionary.values():
		if min > value.size():
			min = value.size()
	
	if min > 0:
		for key in pose_track_dictionary:
			var array = pose_track_dictionary[key] as Array
			for i in min:
				array.remove_at(0)
		for sub : DebateSubscriber in subscriber_array: await sub.on_lines_cleared(min)

func push_top_to_queue(top : Top):
	blackboard.add("previous_top", blackboard.get_value("current_top"), Constants.ExpirationToken.ON_DEBATE_START)
	blackboard.add("previous_pose", blackboard.get_value("current_pose"), Constants.ExpirationToken.ON_DEBATE_START)
	
	pose_track_dictionary[top.data.pose.name].append(top)
	top_history.append(top)
	
	blackboard.add("current_top", top.data.title, Constants.ExpirationToken.ON_DEBATE_START)
	blackboard.add("current_pose", top.data.pose.name, Constants.ExpirationToken.ON_DEBATE_START)
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_top_board_updated(pose_track_dictionary)

func remove_top_from_queue(top : Top):
	var top_queue : Array[Top] = pose_track_dictionary[top.data.pose.name]
	var index = top_queue.find(top)
	
	if index < 0: return
	
	top_queue.remove_at(index)
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_top_board_updated(pose_track_dictionary)

func on_hand_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_hand_updated(contestant)

func on_energy_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_energy_updated(contestant)

func on_deck_updated(contestant : Contestant):
	for sub : DebateSubscriber in subscriber_array: await sub.on_deck_updated(contestant)

func play_top(top : Top, use_action : bool = true):
	await push_top_to_queue(top)
	
	for sub : DebateSubscriber in subscriber_array: await sub.on_top_played(top, active_contestant)
	
	if(use_action):
		await top.data.action.invoke()
