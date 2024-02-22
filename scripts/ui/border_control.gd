@tool
extends Control

@export var top_bar : ColorRect
@export var bottom_bar : ColorRect

@export var amount : float = .1

func _process(delta):
	if !top_bar or !bottom_bar:
		return
	
	top_bar.anchor_bottom = amount
	bottom_bar.anchor_top = 1 - amount
