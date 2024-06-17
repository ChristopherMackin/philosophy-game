@tool
extends Resource

class_name StateDatabase

@export var schema : DBConst.DBSchema

var columns : Array:
	get: return DBConst.db_schema_data[schema]

@export var prefix : String = ""

@export var sub_path : String
var path : String:
	get: return Constants.save_path + sub_path 
var _dictionary : DictionaryVariable

func get_column(key : String):
	for col in columns:
		if col.key == key:
			return col
	
	return null

func update_value(key : String, value) -> bool:
	var col = get_column(key)
	if !col:
		return false
	
	if typeof(value) == col.type:
		_dictionary.value[prefix + key] = value
		return true
	else:
		return false

func get_value(key : String):
	var col = get_column(key)
	if !col:
		return null
	
	return _dictionary.value[prefix + key]

func clean_up():
	for col in columns:
		if !_dictionary.value.has(prefix + col.key):
			update_value(col.key, col.default)
	
	var col_keys = columns.map(func(x): return prefix + x.key)
	var dic_keys = _dictionary.value.keys()
	
	var keys_to_remove = difference(dic_keys, col_keys)
	
	for k in keys_to_remove:
		_dictionary.value.erase(k)

func clear():
	_dictionary.value.clear()
	clean_up()

func difference(arr1, arr2):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1

func load_database():
	if ResourceLoader.exists(path):
		_dictionary = ResourceLoader.load(path)
	else:
		_dictionary = DictionaryVariable.new()
		ResourceSaver.save(_dictionary, path)
	
	clean_up()

func save_database():
	print(path)
	ResourceSaver.save(_dictionary, path)

func build_query() -> Dictionary:
	return _dictionary.value.duplicate()
