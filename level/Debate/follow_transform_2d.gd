extends CanvasItem

class_name FollowTransform2D

@export var target : Node
@export var offset : Vector2

func _ready():
	if !"global_position" in self:
		queue_free()

func _process(delta):
	if target != null:
		if !self.visible:
			self.visible = true
		
		self.global_position = target.global_position + offset
		
	elif self.visible:
		self.visible = false
