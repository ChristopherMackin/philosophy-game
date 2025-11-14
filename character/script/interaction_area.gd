extends Area3D

class_name InteractionArea

var focused_interactable: Interactable

func _ready():
	area_entered.connect(focus_interactable)
	area_exited.connect(unfocus_interactable)

func focus_interactable(area):
	if not area is Interactable: return
	focused_interactable = area

func unfocus_interactable(area):
	if not area is Interactable: return
	if focused_interactable != area: return
	focused_interactable = null
