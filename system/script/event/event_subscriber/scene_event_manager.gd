extends EventSubscriber

class_name SceneEventManager

@export var scene_animator_handler: AnimationHandler
@export var animated_characters: Array[AnimatedCharacter]
var active_speaker: AnimatedCharacter:
	get:
		return active_speaker
	set(val):
		if active_speaker:
			active_speaker.layer_mask.set_layer(20, false)
			active_speaker.dialgoue_camera.priority = 0
		
		active_speaker = val
		
		if active_speaker:
			active_speaker.layer_mask.set_layer(20, true)
			active_speaker.dialgoue_camera.priority = 1

@export var default_dialogue_area: DialogueArea

func _ready():
	super._ready()
	if default_dialogue_area:
		default_dialogue_area.visible = false
	for animated_character in animated_characters:
		if animated_character.dialogue_area_override: animated_character.dialogue_area_override.visible = false

func display_dialogue(line : String, actor : String, await_input : bool, seconds_before_close : float):
	var index = get_actor_index(actor)
	if index < 0:
		push_error("MISSING LINE \nACTOR: \"%s\"\n LINE: %s" % [actor, line])
		return
	
	var animated_character = animated_characters[index]
	var dialogue_area = default_dialogue_area if animated_character.dialogue_area_override == null else animated_character.dialogue_area_override
	
	active_speaker = animated_character
	dialogue_area.visible = true
	dialogue_area.set_text(line, actor)
	animated_character.is_talking = true
	
	await dialogue_area.on_dialogue_finished
	
	animated_character.is_talking = false
	await GlobalTimer.wait_for_seconds(seconds_before_close)
	dialogue_area.visible = false
	active_speaker = null

func cancel_dialogue(actor):
	var index = get_actor_index(actor)
	var animated_character = animated_characters[index]
	var dialogue_area = default_dialogue_area if animated_character.dialogue_area_override == null else animated_character.dialogue_area_override

	dialogue_area.visible = false
	active_speaker = null

func play_animation(animation : String, actor : String, await_animation : bool):
	var parent
	var animation_handler: AnimationHandler
	
	if actor != "":
		var index = get_actor_index(actor)
		
		if index < 0:
			return
			
		parent = animated_characters[index]
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
			
		parent = animated_characters[index]
		animation_handler = parent.get_node_or_null(NodePath("AnimationHandler"))

	
	else:
		animation_handler = scene_animator_handler
	
	animation_handler.cancel_animation()

func get_actor_index(actor_name : String) -> int:
	return animated_characters.map(func(x): return x.name.to_snake_case()).find(actor_name.to_snake_case())
