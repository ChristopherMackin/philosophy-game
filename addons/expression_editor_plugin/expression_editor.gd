extends EditorProperty

# The main control for editing the property.
var property_control = CodeEdit.new()

func _init():
	property_control = ControlHelper.create_expression_editor()
	property_control.text_changed.connect(code_request_code_completion)

	# Add the control as a direct child of EditorProperty node.
	add_child(property_control)
	
	(func() :property_control.text = get_edited_object()[get_edited_property()]).call_deferred()

func code_request_code_completion():
	emit_changed(get_edited_property(), property_control.text)
