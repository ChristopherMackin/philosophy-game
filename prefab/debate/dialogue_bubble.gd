@tool
extends TextureRect

class_name DialogueBubble

@export var scrolling_text : ScrollingText

@export var normal_characters_per_second : int
@export var quick_characters_per_second : int

func _ready():
	set_speed_to_normal()

func set_text(text : String):
	await scrolling_text.set_scrolling_text(text)

func set_speed_to_normal():
	scrolling_text.characters_per_second = normal_characters_per_second

func set_speed_to_quick():
	scrolling_text.characters_per_second = quick_characters_per_second

func skip_to_the_end():
	scrolling_text.skip_to_the_end()
