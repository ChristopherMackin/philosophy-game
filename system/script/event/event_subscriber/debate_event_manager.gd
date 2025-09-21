extends EventSubscriber

class_name DebateEventManager

@export var scene_animator_handler: AnimationHandler
@export var actors: Array[Node]

func display_dialogue(line : String, actor : String, await_input : bool, seconds_before_close : float):
	var index = get_actor_index(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	
	var dialogue_handler : DialogueHandler\
	 = parent.get_node_or_null(NodePath("DialogueHandler"))
	
	dialogue_handler.start_dialogue.call_deferred(line)
	await dialogue_handler.on_dialogue_finished
	await GlobalTimer.wait_for_seconds(seconds_before_close)
	dialogue_handler.close_dialogue()

func cancel_dialogue(actor):
	var index = get_actor_index(actor)
	if index < 0:
		return
	
	var parent = actors[index]
	
	var dialogue_handler : DialogueHandler\
	 = parent.get_node_or_null(NodePath("DialogueHandler"))
	
	dialogue_handler.cancel_dialogue()

func play_animation(animation : String, actor : String, await_animation : bool):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
		
	animation_handler.start_animation(animation)
	
	if await_animation:
		var finished_animation
		while finished_animation != animation:
			finished_animation = await animation_handler.on_animation_finished
			print("finished_animation")

func cancel_animation(actor):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = actors[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
	
	animation_handler.cancel_animation()

func get_actor_index(actor_name : String) -> int:
	return actors.map(func(x): return x.name.to_snake_case()).find(actor_name.to_snake_case())
