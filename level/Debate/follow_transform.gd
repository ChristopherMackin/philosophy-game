extends Node

class_name Selector

@export var target : Node

func _ready():
	if !"global_position" in self:
		queue_free()

func _process(delta):
	if target:
		if !self.visible:
			self.visible = true
		
		self.global_position = target.global_position
		
	elif self.visible:
		self.visible = false
