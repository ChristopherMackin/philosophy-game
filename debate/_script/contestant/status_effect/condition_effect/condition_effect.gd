extends StatusEffect

class_name ConditionEffect

enum Application{
	CAN_DRAW,
	CAN_PLAY
}

@export var application: Application

func check() -> bool:
	return false

func apply(contestant: Contestant):
	super.apply(contestant)
	match application:
		Application.CAN_DRAW:
			contestant.can_draw_condition_effects.add(self)
		Application.CAN_PLAY:
			contestant.can_play_condition_effects.add(self)

func remove(contestant: Contestant):
	super.remove(contestant)
	match application:
		Application.CAN_DRAW:
			var index = contestant.can_draw_condition_effects.find(self)
			contestant.can_draw_condition_effects.remove_at(index)
		Application.CAN_PLAY:
			var index = contestant.can_play_condition_effects.find(self)
			contestant.can_play_condition_effects.remove_at(index)
