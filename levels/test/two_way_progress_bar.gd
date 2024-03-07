@tool
extends VBoxContainer

class_name TwoWayProgressBar

@export var positive_progress_bar : MarkedProgressBar
@export var negative_progress_bar : MarkedProgressBar

@export var positive_tint : Color = Color.WHITE:
	get: return positive_tint
	set(val):
		positive_tint = val
		if not val:
			positive_tint = Color.WHITE
		
		positive_progress_bar.tint_under = val
		positive_progress_bar.tint_progress = val
		positive_progress_bar.tint_over = Color.WHITE
	
@export var negative_tint : Color = Color.WHITE:
	get: return negative_tint
	set(val):
		negative_tint = val
		if not val:
			negative_tint = Color.WHITE
		
		negative_progress_bar.tint_under = val
		negative_progress_bar.tint_progress = val
		negative_progress_bar.tint_over = Color.WHITE

@export var max_value : float:
	get: return max_value
	set(value):
		max_value = value
		positive_progress_bar.max_value = max_value
		negative_progress_bar.max_value = max_value

@export var value : float:
	get: return value
	set(val):
		value = val
		positive_progress_bar.value = 0
		negative_progress_bar.value = 0
			
		if value > 0:
			positive_progress_bar.value = value
		
		if value < 0:
			negative_progress_bar.value = abs(value)
