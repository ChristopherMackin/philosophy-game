extends EventSubscriber

class_name DebateEventSubscriber

@export var scrolling_text : ScrollingText
@onready var root = $".."

func display_dialogue(text : String):
	await scrolling_text.set_scrolling_text(text)

func play_animation(name : String, actor : String, await_animation : bool):
	var node = root.find_child(actor)
	
	if await_animation:
		await node.play_await(name)
	else: 
		node.play(name)
