class_name SceneChangeTrigger
extends SceneChangeNode

func _ready():
	if !has_signal("body_entered"):
		push_error("ERROR: %s has type %s; it must be an area3d" % [name, typeof(self)])
		return
	
	await Global.create_timer(.2)
	self.body_entered.connect(transition_scene.unbind(1))
