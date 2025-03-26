extends Object

class_name SelectionRequest

var options: Array
var action : Const.SelectionAction
var type: Const.SelectionType
var visible_to_player: bool

func _init(options: Array = [], \
	action: Const.SelectionAction = Const.SelectionAction.PLAY, \
	type: Const.SelectionType = Const.SelectionType.CARD, \
	visible_to_player: bool = true):
	
	self.options = options
	self.action = action
	self.type = type
	self.visible_to_player = visible_to_player
