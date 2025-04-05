extends Resource

class_name CardAction

enum Type {
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

func invoke(_caller : Card, _player : Contestant, _manager : DebateManager) -> bool:
	return true
