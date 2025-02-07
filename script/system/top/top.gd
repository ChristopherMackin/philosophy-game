extends Object

#This class exists so that each top is unique
class_name Top

var data : TopData
var manager : DebateManager

var cost : int :
	get: return data.get_cost(manager)

func _init(top_data: TopData, manager : DebateManager):
	data = top_data
	self.manager = manager
