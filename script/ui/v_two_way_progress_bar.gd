@tool
extends VBoxContainer

class_name VTwoWayProgressBar

@export var positive_progress_bar : MarkedProgressBar
@export var negative_progress_bar : MarkedProgressBar

@export var positive_tint : Color = Color.WHITE:
	get: return positive_tint
	set(val):
		positive_tint = val
		if not val:
			positive_tint = Color.WHITE
		
		if positive_progress_bar:
			positive_progress_bar.tint_under = val
			positive_progress_bar.tint_progress = val
			positive_progress_bar.tint_over = Color.WHITE
	
@export var negative_tint : Color = Color.WHITE:
	get: return negative_tint
	set(val):
		negative_tint = val
		if not val:
			negative_tint = Color.WHITE
		
		if negative_progress_bar:
			negative_progress_bar.tint_under = val
			negative_progress_bar.tint_progress = val
			negative_progress_bar.tint_over = Color.WHITE

@export var max_value : float:
	get: return max_value
	set(value):
		max_value = value
		
		if positive_progress_bar:
			positive_progress_bar.max_value = max_value
		
		if negative_progress_bar:
			negative_progress_bar.max_value = max_value

@export var value : float:
	get: return value
	set(val):
		value = val
		
		if not positive_progress_bar or not negative_progress_bar:
			return
		
		positive_progress_bar.value = 0
		negative_progress_bar.value = 0
			
		if value > 0:
			positive_progress_bar.value = value
		
		if value < 0:
			negative_progress_bar.value = abs(value)
