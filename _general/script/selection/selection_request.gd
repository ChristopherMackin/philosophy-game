class_name SelectionRequest
extends Object

var options: Array
var action: Const.SelectionAction
var type: Const.SelectionType
var visible_to_player: bool
var amount: int
var min_amount: int
var caller

var is_card_play_request:
	get():
		return action == Const.SelectionAction.PLAY and type == Const.SelectionType.CARD

func _init(options: Array = [], \
	action: Const.SelectionAction = Const.SelectionAction.PLAY, \
	type: Const.SelectionType = Const.SelectionType.CARD, \
	visible_to_player: bool = true, amount: int = -1, min_amount: int = -1):
	
	self.options = options
	self.action = action
	self.type = type
	self.visible_to_player = visible_to_player
	self.amount = amount
	self.min_amount = min_amount
