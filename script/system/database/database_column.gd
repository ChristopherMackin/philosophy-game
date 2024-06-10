extends Resource

class_name DatabaseColumn

@export var key : String
@export var type : Variant.Type
@export var _default : String
var default:
	get: return type_convert(_default, type)
@export_multiline var description : String
