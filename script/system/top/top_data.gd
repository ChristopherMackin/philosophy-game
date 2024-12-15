extends Resource

class_name TopData

@export var base_cost : int
var cost : int:
	get: return cost_modifier.modify_cost(base_cost)

@export var pose : Pose
@export var title : String
@export var artwork : Texture2D
@export_multiline var description : String
@export var action : TopAction = TopAction.new()
@export var cost_modifier : TopCostModifier = TopCostModifier.new()
@export var tags : Array[Constants.Tag]
