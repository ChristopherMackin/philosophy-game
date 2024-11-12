extends Node3D

@export var scrolling_text: ScrollingText

func say(line : String):
	await scrolling_text.set_scrolling_text(line)
