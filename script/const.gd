extends Object

class_name Const

const save_path : String = "res://_save/"
#const save_path : String = "user://save/"

enum Tag {
	BASIC,
	EVIDENCE
}

enum ExpirationToken {
	NEVER,
	ON_GAME_RESET,
	ON_DEBATE_START,
	ON_TURN_END,
	ON_TURN_START,
	ON_ACTION_END
}

enum WhichContestant {
	SELF,
	OPPONENT
}

static func GetContestant(player, opponent, which_contestant) -> Contestant:
	return player if which_contestant == Const.WhichContestant.SELF else opponent


enum Player {
	HUMAN,
	COMPUTER
}

enum CardActionType {
	ON_PLAY,
	ON_DISCARD,
	ON_BANISH,
	ON_TURN_START,
	ON_TURN_END,
	ON_HOLD_START,
	ON_HOLD_STAY,
	ON_HOLD_END
}

enum SelectionAction {
	VIEW,
	SINGLE,
	MULTI,
	ALL,
	FIRST,
	PLAY
}

enum SelectionType {
	TOKEN,
	CARD,
	SUIT
}

enum Direction {
	LEFT,
	RIGHT
}

enum CardCollection {
	HAND,
	DRAW_PILE,
	DECK,
	DISCARD,
	PLAY_STACK,
}
