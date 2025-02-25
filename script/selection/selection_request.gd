extends Object

class_name SelectionRequest

var options: Array
var what: String
var type: String
var visible_to_player: bool

func _init(options: Array = [], what: String = "play", type : String = "card", visible_to_player: bool = true):
	self.options = options
	self.what = what
	self.type = type
	self.visible_to_player = visible_to_player
