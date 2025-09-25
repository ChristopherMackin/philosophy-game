extends EventSubscriber

class_name SceneEventManager

@export var scene_animator_handler: AnimationHandler
@export var actors: Array[Actor]

@export var default_dialogue_area: DialogueArea

func _ready():
	super._ready()
	if default_dialogue_area:
		default_dialogue_area.visible = false
	for actor in actors:
		if actor.dialogue_area_override: actor.dialogue_area_override.visible = false

func display_dialogue(line : String, actor : String, await_input : bool, seconds_before_close : float):
	var index = get_actor_index(actor)
	if index < 0:
		push_error("MISSING LINE \nACTOR: \"%s\"\n LINE: %s" % [actor, line])
		return
	
	var current_actor = actors[index]
	var dialogue_area = default_dialogue_area if current_actor.dialogue_area_override == null else current_actor.dialogue_area_override
	
	current_actor.focus_actor(true)
	dialogue_area.visible = true
	dialogue_area.set_text(line, current_actor.dialogue_display_name)
	current_actor.is_talking = true
	
	await dialogue_area.on_dialogue_finished
	
	current_actor.is_talking = false
	await GlobalTimer.wait_for_seconds(seconds_before_close)
	dialogue_area.visible = false
	current_actor.focus_actor(false)

func cancel_dialogue(actor):
	var index = get_actor_index(actor)
	var current_actor = actors[index]
	var dialogue_area = default_dialogue_area if current_actor.dialogue_area_override == null else current_actor.dialogue_area_override

	dialogue_area.visible = false
	current_actor.focus_actor(false)

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
