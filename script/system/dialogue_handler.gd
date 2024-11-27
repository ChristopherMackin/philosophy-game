extends Node

class_name DialogueHandler

signal on_stop_dialogue

@export var facial_animator : FacialAnimator
@export var default_dialogue_bubble : DialogueBubble

func _ready():
	default_dialogue_bubble.visible = false
	default_dialogue_bubble.on_stop_dialogue.connect(cancel_dialogue)

func start_dialogue(line : String):
	facial_animator.mouth_state = FacialAnimator.MouthState.TALKING
	default_dialogue_bubble.visible = true
	default_dialogue_bubble.set_text(line)

func cancel_dialogue():
	default_dialogue_bubble.stop_scrolling()
	facial_animator.mouth_state = FacialAnimator.MouthState.CLOSED
	default_dialogue_bubble.visible = false
	on_stop_dialogue.emit()
