extends RichTextLabel

class_name ScrollingText

signal on_scoll_completed

@export var centiseconds_between_characters : float
var seconds_between_characters : float : 
	get: 
		return centiseconds_between_characters/100
var timer : float
var is_scrolling : bool

func _process(delta):
	if !is_scrolling:
		return
	
	timer += delta
	
	if timer >= seconds_between_characters:
		timer -= seconds_between_characters
		visible_characters += 1
		if visible_characters >= text.length():
			on_scoll_completed.emit()
			is_scrolling = false

func set_scrolling_text(scrolling_text : String):
	timer = 0
	text = scrolling_text
	visible_characters = 0
	is_scrolling = true
