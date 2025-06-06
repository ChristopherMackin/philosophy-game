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

static func GetContestant(player, opponent, which_contestant) -> Contestant:
	return player if which_contestant == Const.WhichContestant.SELF else opponent

enum Player {
	HUMAN,
	COMPUTER
}

enum SelectionAction {
	VIEW,
	SINGLE,
	MULTI,
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

enum Concept{
	#DEBATE
	ON_PLAY,
	ON_HOLD,
	ON_DEBATE_START,
	ON_DEBATE_END,
	#OVERWORLD
	ON_SCENE_ENTER
}

const Autocomplete = [
	"player",
	"computer",
	"active_contestant",
	"current_turn",
	"current_round",
	"card_history",
	"turn_card_history",
	"token_history",
	"turn_token_history",
	"action_added_cost_modifier",
	"action_added_card_base",
	"action_moved_cards",
	"action_discarded_cards",
	"action_bniahsed_cards",
	"action_viewed_cards",
	"action_",
]
