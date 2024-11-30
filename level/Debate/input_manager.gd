extends Node

@export var hand : HandUI
@export var selector : Selector

@export var selected_index : int:
	set(val):
		if !hand:
			return
		
		if val >= hand.hand_3d.size():
			val = hand.hand_3d.size() - 1
		
		selected_index = val
		
		selector.target = hand.hand_3d[selected_index]
