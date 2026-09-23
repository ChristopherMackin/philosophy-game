extends Object

class_name Const

const save_path : String = "res://_save/"
#const save_path : String = "user://save/"

enum Tag {
	BASIC,
	EVIDENCE,
	SUPERNATURAL
}

enum WhichContestant {
	SELF,
	OPPONENT
}

static func get_contestant(player, opponent, which_contestant) -> Contestant:
	return player if which_contestant == Const.WhichContestant.SELF else opponent

enum Player {
	HUMAN,
	COMPUTER
}

enum SelectionAction {
	VIEW,
	SELECT,
	PLAY,
	OTHER
}

enum SelectionType {
	TOKEN,
	CARD,
	SUIT,
	OTHER
}

enum Direction {
	LEFT,
	RIGHT
}

enum Concept {
	#DEBATE
	ON_PLAY,
	ON_HOLD,
	ON_ACTION_INVOKED,
	ON_TOKENS_PLAYED,
	ON_LINES_CLEARED,
	ON_CARD_DRAWN,
	ON_TURN_START,
	ON_TURN_END,
	ON_DEBATE_START,
	ON_DEBATE_END,
	#GLOBAL
	ON_SCENE_ENTER,
	ON_EVENT_TRIGGER_INVOKED
}

enum Emotion{
	REST,
	SAD,
}

enum SFX {
	
}

enum VFX {
	
}

const Autocomplete = [
	"HUMAN",
	"COMPUTER"
]
