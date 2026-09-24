extends RichTextLabel

class_name RichTextLableUpdateEmitter

signal on_label_updated(text: String)

var is_initialized:= false

func _ready():
	await GlobalTimer.wait_for_seconds(.01)
	is_initialized = true

func update_label(text: String):
	if self.text == text: return
	
	self.text = text
	
	if !is_initialized: return
	
	on_label_updated.emit(text)
	
