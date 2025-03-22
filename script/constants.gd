extends Object

class_name Constants

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
}

enum WhichContestant {
	SELF,
	OPPONENT
}

static func GetContestant(player, opponent, which_contestant):
	return player if which_contestant == Constants.WhichContestant.SELF else opponent


enum Player {
	HUMAN,
	COMPUTER
}

enum ActionType {
	ON_PLAY,
	ON_DISCARD,
	ON_BANISH,
	ON_TURN_START,
	ON_TURN_END,
	ON_HOLD_START,
	ON_HOLD_STAY,
	ON_HOLD_END
}
