extends Object

#This class exists so that each top is unique
class_name Top

var data : TopData

func _init(top_data: TopData, manager : DebateManager):
	data = top_data
	data.action.manager = manager
	data.action.top_data = top_data
	
	data.cost_modifier.manager = manager
	data.cost_modifier.top_data = top_data
