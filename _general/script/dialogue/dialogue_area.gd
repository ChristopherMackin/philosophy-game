@tool
extends Control

class_name DialogueArea

signal on_dialogue_finished

@export var scrolling_text: ScrollingText:
	set(val):
		if scrolling_text and scrolling_text.on_scroll_completed.is_connected(emit_dialogue_complete):
			scrolling_text.on_scroll_completed.disconnect(emit_dialogue_complete)
		
		scrolling_text = val
		
		if scrolling_text and !scrolling_text.on_scroll_completed.is_connected(emit_dialogue_complete):
			scrolling_text.on_scroll_completed.connect(emit_dialogue_complete)

@export var speaker_label: RichTextLabel
@export var speaker_control: Control

@export var normal_characters_per_second : int:
	get:
		return scrolling_text.characters_per_second if scrolling_text else 0
	set(val):
		if scrolling_text:
			scrolling_text.characters_per_second = val

func emit_dialogue_complete():
	on_dialogue_finished.emit()

func set_text(text: String, speaker_name: String = ""):
	if speaker_label && speaker_control && speaker_name != "": 
		speaker_control.visible = true
		speaker_label.text = speaker_name
	else:
		if speaker_control: speaker_control.visible = false
		
	scrolling_text.set_scrolling_text(text)

func stop_scrolling():
	scrolling_text.is_scrolling = false

func skip_to_the_end():
	scrolling_text.skip_to_the_end()
