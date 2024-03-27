extends Node2D

class_name ContestantDisplay

@export var anim_tree : AnimationTree
@export var ui_card : UICard

signal animation_finished

func play_card(card : Card):
	ui_card.initialize(card, func(): pass)
	anim_tree["parameters/conditions/has_played"] = true
