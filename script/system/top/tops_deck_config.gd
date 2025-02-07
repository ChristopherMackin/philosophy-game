extends Resource

class_name TopsDeckConfig

@export var top_data : TopData
@export var count : int

func _init(top_data : TopData = null, count : int = 0):
	self.top_data = top_data
	self.count = count
