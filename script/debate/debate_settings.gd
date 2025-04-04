@tool
extends Resource

class_name DebateSettings

@export_group("Player Settings")
@export var starting_player : Const.Player = Const.Player.HUMAN
@export var redraw_on_hand_depleted : bool = true
@export var retain_excess_energy : bool = true

@export_group("Board Settings")
@export var suits : Array[Suit]
@export var slots : int = 8
@export var line_clear_direction : Const.Direction

@export_group("Game End Conditions")
@export var game_end_conditions: Array[GameEndCondition] = [
	SuitTrackFilledEndCondition.new(),
	EmptyHandEndCondition.new()
]
