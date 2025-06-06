@tool
extends SubViewport

@export var control: Control:
	set(val):
		if control:
			control.resized.disconnect(resize_viewport)
		
		control = val
		
		if control:
			control.resized.connect(resize_viewport)
		
		resize_viewport()


func resize_viewport():
	size = control.size
