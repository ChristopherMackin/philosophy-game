extends Object

class_name ControlHelper

static func get_value(control : Control):
	if control is TextEdit:
		return control.text
	if control is SpinBox:
		return control.value
	if control is CheckButton:
		return control.button_pressed
	if control is CustomResourceLoader:
		return control.path
	if control is OptionButton:
		return control.get_item_id(control.selected)
	if control is EditorResourcePicker:
		return control.edited_resource

static func set_value(control : Control, value = null):
	if !value:
		return
	
	if control is TextEdit:
		control.text = value 
	elif control is SpinBox:
		control.value = value
	elif control is CheckButton: 
		control.button_pressed = value
	elif control is CustomResourceLoader:
		control.path = value
	elif control is OptionButton:
		control.select(control.get_item_index(value))
	elif control is EditorResourcePicker:
		control.edited_resource = value

static func instantiate_control_from_variant_type(prop, value_changed_callback: Callable = func(this_control: Control): pass) -> Control:
	var type = prop["type"]
	
	if !type: return null
	
	var hint = prop["hint"]
	
	match type:
		TYPE_STRING:
			var control
			if hint == PROPERTY_HINT_EXPRESSION:
				control = create_expression_editor(value_changed_callback)
			else:
				control = TextEdit.new()
			return control
		_: return null


static func create_expression_editor(value_changed_callback: Callable = func(this_control: Control): pass) -> CodeEdit:
	var property_control = CodeEdit.new()
	
	var code_request_code_completion = func():
		if property_control.get_word_at_pos(property_control.get_caret_draw_pos()) != "":
			for option in Const.Autocomplete:
				property_control.add_code_completion_option(CodeEdit.KIND_VARIABLE, option, option)
		
		property_control.update_code_completion_options(true)
	
	property_control.custom_minimum_size = Vector2(500, 360)
	property_control.text_changed.connect(code_request_code_completion)
	property_control.text_changed.connect((func(): value_changed_callback.call(property_control)))
	property_control.code_completion_enabled = true
	property_control.gutters_draw_bookmarks
	
	return property_control

static func create_text_area(value_changed_callback: Callable = func(this_control: Control): pass) -> TextEdit:
	var control = TextEdit.new()
	return control

static func create_text_box(value_changed_callback: Callable = func(this_control: Control): pass) -> TextEdit:
	var control = TextEdit.new()
	return control
