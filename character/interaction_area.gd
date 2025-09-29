extends Area3D

class_name InteractionArea

var focused_interactable: Interactable

func _ready():
	body_entered.connect(focus_interactable)
	body_exited.connect(unfocus_interactable)

func focus_interactable(body: Node):
	if not body is Interactable: return
	focused_interactable = body

func unfocus_interactable(body: Node):
	if not body is Interactable: return
	if focused_interactable != body: return
	focused_interactable = null
