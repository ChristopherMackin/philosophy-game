extends Resource

class_name DatabaseColumn

@export var key : String
@export var type : Variant.Type
@export var _default : String
var default:
	get: return str_to_var(_default)
@export_multiline var description : String
