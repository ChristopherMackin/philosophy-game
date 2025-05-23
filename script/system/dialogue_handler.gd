extends Node

class_name DialogueHandler

signal on_dialogue_finished

@export var facial_animator : FacialAnimator
@export var default_dialogue_bubble : DialogueBubble

func _ready():
	default_dialogue_bubble.visible = false
	default_dialogue_bubble.on_dialogue_finished.connect(dialogue_finished)

func start_dialogue(line : String):
	default_dialogue_bubble.visible = true
	default_dialogue_bubble.set_text(line)

func close_dialogue():
	default_dialogue_bubble.stop_scrolling()
	default_dialogue_bubble.visible = false

func dialogue_finished():
	on_dialogue_finished.emit()

func cancel_dialogue():
	close_dialogue()
