@tool
extends Resource

class_name DebateSettings

@export var starting_player : Const.Player = Const.Player.HUMAN
@export var redraw_on_hand_depleted : bool = true
@export var slots : int = 8
@export var suits : Array[Suit]
