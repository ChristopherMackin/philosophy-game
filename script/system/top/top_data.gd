extends Resource

class_name TopData

@export var base_cost : int
@export var pose : Pose
@export var title : String
@export var artwork : Texture2D
@export_multiline var description : String
@export var on_play_top_action : Array[TopAction]
@export var on_discard_top_action : Array[TopAction]
@export var on_banish_top_action : Array[TopAction]
@export var cost_modifier : TopCostModifier = TopCostModifier.new()
@export var tag : Constants.Tag

func get_cost(manager : DebateManager) -> int:
	return cost_modifier.modify_cost(base_cost, manager)
