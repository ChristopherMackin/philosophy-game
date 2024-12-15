extends Resource

class_name TopData

@export var cost : int
@export var pose : Pose
@export var title : String
@export var artwork : Texture2D
@export_multiline var description : String
@export var action : TopAction = TopAction.new()
@export var tags : Array[TopTags.Tag]
