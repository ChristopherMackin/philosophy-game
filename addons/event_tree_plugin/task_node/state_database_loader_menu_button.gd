extends MenuButton

class_name CustomResourceLoader

signal on_resource_loaded(path)

var path : String = "" :
	set(value):
		path = value
		var path_array : Array = path.split("/")
		text = path_array.back()
		on_resource_loaded.emit(path)
var dialogue : FileDialog

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	dialogue = FileDialog.new()
	dialogue.add_filter("*.tres")
	dialogue.size = Vector2(400, 400)
	dialogue.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialogue.connect("file_selected", file_selected)
	add_child(dialogue)
	
	get_popup().connect("id_pressed", load_pressed)

func load_pressed(index):
	dialogue.visible = true

func file_selected(path):
	if !ResourceLoader.exists(path):
		return
	
	self.path = path
	
	dialogue.visible = false
	
