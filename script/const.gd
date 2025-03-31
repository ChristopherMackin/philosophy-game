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
	ON_DRAW,
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
	ON_PLAY,
	ON_HOLD,
	ON_DEBATE_START,
	ON_DEBATE_END,
}

const autocomplete = [
	"player",
	"computer",
	"active_contestant",
	"current_turn",
	"current_round",
	"previous_card",
	"current_card",
	"action_added_cost_modifier",
	"action_added_card_base",
	"action_moved_cards",
	"action_discarded_cards",
	"action_bniahsed_cards",
	"action_viewed_cards",
	"action_",
]
