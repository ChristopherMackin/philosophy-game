extends EventSubscriber

class_name DebateEventSubscriber

@export var scene_animator : Node
@export var actors : Array[Node]

func display_dialogue(line : String, actor : String):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var actor_node = actors[index]
	
	actor_node.start_dialogue.call_deferred(line)
	await actor_node.on_stop_dialogue

func cancel_dialogue(actor):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var actor_node = actors[index]
	
	actor_node.stop_dialogue()

func play_animation(name : String, actor : String, await_animation : bool):
	var parent
	
	if actor != "":
		var index = actors.map(func(x): return x.name).find(actor)
		if index < 0:
			return
		parent = actors[index]
	else:
		parent = scene_animator
	
	var animator : AnimationPlayer = parent.get_node_or_null(NodePath("AnimationPlayer"))
	
	if await_animation:
		animator.play(name)
		await animator.animation_finished
	else: 
		animator.play(name)
