@tool
extends Sprite2D

class_name DebateProfileUI

enum ProfileState {
	IDLE,
	PLAY_CARD,
}

var state : ProfileState = ProfileState.IDLE

func set_state(state : ProfileState):
	self.state = state
