@tool
extends RichTextLabel

class_name ScrollingText

signal on_scroll_completed

@export var characters_per_second : int
var seconds_between_characters : float : 
	get: 
		return 1.0 / characters_per_second

@export_range(0, 1) var normalized_dialogue_position: float:
	get(): return visible_ratio
	set(val): visible_ratio = val

var length_in_seconds : float
var is_scrolling : bool

func _process(delta):
	if !is_scrolling:
		return
	
	normalized_dialogue_position += delta / length_in_seconds
	
	visible_ratio = normalized_dialogue_position
	if visible_ratio >= 1:
		is_scrolling = false
		normalized_dialogue_position = 1;
		on_scroll_completed.emit()

func set_scrolling_text(scrolling_text : String, auto_scroll := true):
	normalized_dialogue_position = 0
	text = scrolling_text
	visible_ratio = 0
	length_in_seconds = get_parsed_text().length() * seconds_between_characters
	is_scrolling = auto_scroll

func skip_to_the_end():
	visible_ratio = 1
	is_scrolling = false
	on_scroll_completed.emit()
