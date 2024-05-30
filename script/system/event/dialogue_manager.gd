extends Node2D

class_name DialogueManager
@export var text_display : ScrollingText

func display_dialogue(text : String):
	await text_display.set_scrolling_text(text)
