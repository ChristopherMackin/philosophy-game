extends EventSubscriber

class_name DebateEventSubscriber

@export var scrolling_text : ScrollingText

func display_dialogue(text : String):
	await scrolling_text.set_scrolling_text(text)
