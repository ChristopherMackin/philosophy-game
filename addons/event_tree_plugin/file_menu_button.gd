@tool
extends MenuButton

class_name FileMenuButton

signal new_clicked
signal open_clicked
signal save_clicked
signal save_as_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().id_pressed.connect(id_selected)

func id_selected(id : int):
	get_popup()
	
	match id:
		0:
			new_clicked.emit()
		1:
			open_clicked.emit()
		3:
			save_clicked.emit()
		4:
			save_as_clicked.emit()
