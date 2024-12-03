extends CanvasItem

class_name SelectableControl

signal on_selected(node : Node)

func select():
	on_selected.emit(get_parent())
