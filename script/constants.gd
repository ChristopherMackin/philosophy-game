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

enum Contestant {
	PLAYER,
	OPPONENT
}
