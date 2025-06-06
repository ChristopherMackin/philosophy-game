extends Node

class_name DialogueHandler

signal on_dialogue_finished

@export var character_animation_tree : CharacterAnimationTree
@export var default_dialogue_bubble : DialogueBubble

func _ready():
	default_dialogue_bubble.visible = false
	default_dialogue_bubble.on_dialogue_finished.connect(dialogue_finished)

func start_dialogue(line : String):
	default_dialogue_bubble.visible = true
	character_animation_tree.is_talking = true
	default_dialogue_bubble.set_text(line)

func close_dialogue():
	default_dialogue_bubble.stop_scrolling()
	default_dialogue_bubble.visible = false

func dialogue_finished():
	character_animation_tree.is_talking = false
	on_dialogue_finished.emit()

func cancel_dialogue():
	close_dialogue()
