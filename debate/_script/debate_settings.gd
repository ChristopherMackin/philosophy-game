@tool
extends Resource

class_name DebateSettings

signal on_value_changed

@export_group("Player Settings")
@export var starting_player : Const.Player = Const.Player.HUMAN:
	set(val):
		starting_player = val
		on_value_changed.emit()
@export var redraw_on_hand_depleted : bool = true:
	set(val):
		redraw_on_hand_depleted = val
		on_value_changed.emit()
@export var retain_excess_energy : bool = true:
	set(val):
		retain_excess_energy = val
		on_value_changed.emit()

@export_group("Board Settings")
@export var suits : Array[Suit]:
	set(val):
		suits = val
		on_value_changed.emit()
@export var slots : int = 8:
	set(val):
		slots = val
		on_value_changed.emit()
@export var line_clear_direction : Const.Direction:
	set(val):
		line_clear_direction = val
		on_value_changed.emit()

@export_group("Game End Conditions")
@export var game_end_conditions: Array[GameEndCondition] = [
	SuitTrackFilledEndCondition.new(),
	EmptyHandEndCondition.new()
]
