extends Node3D

class_name DialogueHandler

@export var emotion_index : int = 0
@export var spawn_location : Node
@export var default_bubble_prefab : PackedScene
@export var emotion_index_prefabs : Array[EmotionIndexPrefab]

func say(line : String):
	pass
