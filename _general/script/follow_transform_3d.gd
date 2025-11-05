extends Node3D

class_name FollowTransform3D

@export var target : Node
@export var offset : Vector3

func _ready():
	if !"global_position" in self:
		queue_free()

func _process(delta):
	if target:
		if !self.visible:
			self.visible = true
		
		self.global_position = target.global_position + offset
		
	elif self.visible:
		self.visible = false
