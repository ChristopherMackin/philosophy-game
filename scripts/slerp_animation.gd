extends Sprite2D

var _starting_position : Vector2
var _target_position : Vector2

@export var slerp_time : float = 1
var timer : float = 0
var is_moving : bool = false

func set_target(position : Vector2):
	is_moving = true
	_starting_position = self.position
	_target_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	set_target(Vector2(100, 100))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_moving:
		return
	
	timer += delta
	
	if timer >= slerp_time:
		timer = slerp_time
		is_moving = false
		print("STOP MOVING")
	

	position = _starting_position.slerp(_target_position, timer/slerp_time)
	print(_starting_position)
		
