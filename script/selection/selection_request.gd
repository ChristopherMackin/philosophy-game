extends Object

class_name SelectionRequest

var options: Array
var what: String
var which_contestant : Const.WhichContestant
var action : Const.SelectionAction
var type: Const.SelectionType
var visible_to_player: bool

func _init(options: Array = [], \
	what: String = "play", \
	which_contestant: Const.WhichContestant = Const.WhichContestant.SELF, \
	action: Const.SelectionAction = Const.SelectionAction.SINGLE, \
	type: Const.SelectionType = Const.SelectionType.CARD, \
	visible_to_player: bool = true):
	
	self.options = options
	self.what = what
	self.which_contestant = which_contestant
	self.action = action
	self.type = type
	self.visible_to_player = visible_to_player
