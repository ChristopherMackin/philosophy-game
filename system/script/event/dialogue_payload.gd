extends Object

class_name DialoguePayload

var line : String
var actor : String
var await_input : bool
var close_timer : float
var await_close : bool

func _init(line: String, actor: String, await_input: bool, close_timer: float, await_close: bool):
	self.line = line
	self.actor = actor
	self.await_input = await_input
	self.close_timer = close_timer

static func from_task(task: Task):
	return DialoguePayload.new(task.get_input("text"), task.get_input("actor"), task.get_input("await_input"), task.get_input("close_timer"), task.get_input("await_close"))
