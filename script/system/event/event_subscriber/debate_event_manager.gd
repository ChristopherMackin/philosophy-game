extends EventSubscriber

class_name DebateEventSubscriber

@export var scrolling_text : ScrollingText
@onready var root = $".."

func display_dialogue(text : String):
	await scrolling_text.set_scrolling_text(text)

func play_animation(name : String, actor : String, await_animation : bool):
	var parent = root.find_child(actor)
	var animator = parent.get_node_or_null(NodePath("AnimationPlayer"))
	
	if await_animation:
		await animator.play_await(name)
	else: 
		animator.play(name)
