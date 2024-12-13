extends AnimationHandler

class_name AnimationPlayerHandler

@export var animation_player : AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(func(anim_name): on_animation_finished.emit())

func start_animation(name : String):
	animation_player.play(name)

func cancel_animation():
	animation_player.play("RESET")
