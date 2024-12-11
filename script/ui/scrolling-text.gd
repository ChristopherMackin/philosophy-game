extends RichTextLabel

class_name ScrollingText

signal on_scroll_completed

@export var characters_per_second : int
var seconds_between_characters : float : 
	get: 
		return 1.0 / characters_per_second
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
			is_scrolling = false
			on_scroll_completed.emit()

func set_scrolling_text(scrolling_text : String):
	timer = 0
	text = scrolling_text
	visible_characters = 0
	is_scrolling = true

func skip_to_the_end():
	visible_characters = text.length()
	is_scrolling = false
	on_scroll_completed.emit()
