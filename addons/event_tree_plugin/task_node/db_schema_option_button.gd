@tool
extends OptionButton

class_name DBSchemaSelector

var schema : DBConst.DBSchema:
	set(value):
		schema = value
		on_schema_selected()

# Called when the node enters the scene tree for the first time.
func on_schema_selected():
	clear()
	for e in DBConst.db_schema[schema]:
		add_item(e, DBConst.db_schema[schema][e])

func _on_item_selected(index):
	var id = get_item_id(index)

func on_resource_loaded(path):
	var db = ResourceLoader.load(path)
	if !db is StateDatabase:
		return
	
	schema = db.schema
