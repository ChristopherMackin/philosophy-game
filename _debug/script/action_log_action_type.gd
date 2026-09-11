extends Object

class_name ActionLogActionType

enum ActionType {
	EVENT_START = 1 << 0,
	EVENT_END = 1 << 1,
	DIALOGUE = 1 << 2,
	ANIMATION = 1 << 3,
	TIMER = 1 << 4,
	TITLE
}

func _init(action_log: String, action_type: ActionType):
	self.action_log = action_log
	self.action_type = action_type

var action_log: String
var action_type: ActionType
