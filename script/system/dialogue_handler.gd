extends Node

class_name DialogueHandler

signal on_dialogue_finished

@export var facial_animator : FacialAnimator
@export var default_dialogue_bubble : DialogueBubble

func _ready():
	default_dialogue_bubble.visible = false
	default_dialogue_bubble.on_dialogue_finished.connect(dialogue_finished)

func start_dialogue(line : String):
	facial_animator.mouth_state = FacialAnimator.MouthState.TALKING
	default_dialogue_bubble.visible = true
	default_dialogue_bubble.set_text(line)

func close_dialogue():
	default_dialogue_bubble.stop_scrolling()
	facial_animator.mouth_state = FacialAnimator.MouthState.CLOSED
	default_dialogue_bubble.visible = false

func dialogue_finished():
	facial_animator.mouth_state = FacialAnimator.MouthState.CLOSED
	on_dialogue_finished.emit()

func cancel_dialogue():
	close_dialogue()
