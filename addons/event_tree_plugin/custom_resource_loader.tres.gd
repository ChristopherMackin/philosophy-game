@tool
extends MenuButton

class_name CustomResourceLoader

signal on_resource_loaded(path : String)

var path : String = "" :
	set(value):
		path = value
		var path_array : Array = path.split("/")
		text = path_array.back()
		on_resource_loaded.emit(path)

var dialogue : FileDialog

func _enter_tree():
	get_popup().id_pressed.connect(_on_id_selected)

func file_selected(path):
	print("PISS")
	if !ResourceLoader.exists(path):
		return
	
	self.path = path

func _on_id_selected(index : int):
	dialogue = FileDialog.new()
	dialogue.add_filter("*.tres")
	dialogue.size = Vector2(400, 400)
	dialogue.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialogue.access = FileDialog.ACCESS_FILESYSTEM
	dialogue.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	
	dialogue.connect("file_selected", file_selected)
	dialogue.visibility_changed.connect(destroy_dialogue)
	
	add_child(dialogue)
	dialogue.visible = true

func destroy_dialogue():
	if dialogue.visible == false:
		dialogue.visibility_changed.disconnect(destroy_dialogue)
		dialogue.queue_free()
