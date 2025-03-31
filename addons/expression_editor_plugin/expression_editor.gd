extends EditorProperty

# The main control for editing the property.
var property_control = CodeEdit.new()
# An internal value of the property.
var current_value = ""
# A guard against internal changes when the property is updated.
var updating = false

func _init():
	property_control.custom_minimum_size = Vector2(500, 360)
	property_control.text_changed.connect(code_request_code_completion)
	property_control.code_completion_enabled = true
	property_control.gutters_draw_bookmarks
	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)

func code_request_code_completion():
	if property_control.get_word_at_pos(property_control.get_caret_draw_pos()) != "":
		for option in Const.autocomplete:
			property_control.add_code_completion_option(CodeEdit.KIND_VARIABLE, option, option)
	
	property_control.update_code_completion_options(true)
