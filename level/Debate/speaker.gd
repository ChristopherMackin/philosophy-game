extends Node3D

class_name Speaker

@export var scrolling_text: ScrollingText

func say(line : String):
	await scrolling_text.set_scrolling_text(line)
