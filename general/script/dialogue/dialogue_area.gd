extends Control

class_name DialogueArea

signal on_dialogue_finished

@export var scrolling_text: ScrollingText
@export var speaker_label: RichTextLabel
@export var speaker_control: Control

@export var normal_characters_per_second : int
@export var quick_characters_per_second : int

func _ready():
	set_speed_to_normal()
	
	scrolling_text.on_scroll_completed.connect(func(): on_dialogue_finished.emit())

func set_text(text: String, speaker_name: String = ""):
	if speaker_label && speaker_control && speaker_name != "": 
		speaker_control.visible = true
		speaker_label.text = speaker_name
	else:
		if speaker_control: speaker_control.visible = false
	
	scrolling_text.set_scrolling_text(text)

func stop_scrolling():
	scrolling_text.is_scrolling = false

func set_speed_to_normal():
	scrolling_text.characters_per_second = normal_characters_per_second

func set_speed_to_quick():
	scrolling_text.characters_per_second = quick_characters_per_second

func skip_to_the_end():
	scrolling_text.skip_to_the_end()
