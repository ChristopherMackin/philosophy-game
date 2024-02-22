extends Resource

class_name DebateManager

@export var debate_settings : DebateSettings

var proactive_contestant : Contestant
var reactive_contestant : Contestant

var score : Vector2:
	get: return score
	set(value):
		score = value
		on_score_updated.emit(value)
	
var play_again : bool = false

var subscriber_array : Array

signal on_score_updated(new_score : Vector2)
#Fix this one soon
signal on_debate_end()

func connect_signals(node : Node):
	var signals := [
		on_debate_end,
		on_score_updated
	]
	
	for sig : Signal in signals:
		var callable
		if node.has_method(sig.get_name()):
			callable = Callable(node, sig.get_name())
			sig.connect(callable)
		else:
			push_error("UNIMPLEMENTED: %s" % sig.get_name())

func init(proactive_character : Character, reactive_character : Character):
	proactive_contestant = Contestant.new(proactive_character)
	reactive_contestant = Contestant.new(reactive_character)
	
	proactive_contestant.ready_up()
	reactive_contestant.ready_up()
	
	game_loop()

func game_loop():
	while !get_is_debate_over():
		var starting_card = await proactive_contestant.take_turn()
		
	
	on_debate_end.emit()

func get_is_debate_over():
	return abs(score.x) >= debate_settings.win_amount || abs(score.y) >= debate_settings.win_amount
