extends RichTextLabel

class_name RichTextLableUpdateEmitter

signal on_label_updated(text: String)

func update_label(text: String):
	if self.text == text: return
	
	self.text = text
	on_label_updated.emit(text)
	
