extends Node3D

class_name Token3d

@onready var mesh_instance: MeshInstance3D = $Token
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("token_on_enter")

func destroy_token():
	animation_player.play("token_on_exit")
	await animation_player.animation_finished
	queue_free()

func reposition_token(pos: Vector3):
	animation_player.play("token_on_exit")
	await animation_player.animation_finished
	position = pos
	animation_player.play("token_on_reenter")

var token: Token:
	set(val):
		token = val
		if !token || !token.artwork: return
	
		_texture = token.artwork

var _texture: Texture2D:
	set(val):
		_texture = val
		if !_texture: return
		
		mesh_instance.material_override = mesh_instance.get_active_material(0).duplicate()
		mesh_instance.material_override.albedo_texture = _texture
