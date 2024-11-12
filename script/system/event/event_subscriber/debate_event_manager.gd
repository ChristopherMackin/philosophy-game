extends EventSubscriber

class_name DebateEventSubscriber

@export var actors : Array[Node]

func display_dialogue(line : String, actor : String):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	var speaker = parent.get_node_or_null(NodePath("Speaker"))
	
	await speaker.say(line)

func play_animation(name : String, actor : String, await_animation : bool):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	var animator = parent.get_node_or_null(NodePath("AnimationPlayer"))
	
	if await_animation:
		await animator.play_await(name)
	else: 
		animator.play(name)
