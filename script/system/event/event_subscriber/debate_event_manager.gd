extends EventSubscriber

class_name DebateEventSubscriber

@export var scene_animator : Node
@export var actors : Array[Node]

func display_dialogue(line : String, actor : String):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	
	var dialogue_handler : DialogueHandler\
	 = parent.get_node_or_null(NodePath("DialogueHandler"))
	
	dialogue_handler.start_dialogue.call_deferred(line)
	await dialogue_handler.on_stop_dialogue

func cancel_dialogue(actor):
	var index = actors.map(func(x): return x.name).find(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	
	var dialogue_handler : DialogueHandler\
	 = parent.get_node_or_null(NodePath("DialogueHandler"))
	
	dialogue_handler.cancel_dialogue()

func play_animation(name : String, actor : String, await_animation : bool):
	var parent
	
	if actor != "":
		var index = actors.map(func(x): return x.name).find(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
	
	else:
		parent = scene_animator
	
	var animation_handler : AnimationHandler = parent.get_node_or_null(NodePath("AnimationHandler"))
	
	animation_handler.start_animation(name)
	
	if await_animation: await animation_handler.on_animation_finished

func cancel_animation(actor):
	pass
