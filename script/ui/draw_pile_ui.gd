extends Node

class_name DrawPileUI

@onready var count_label = $CountLabel

func set_count(count : int):
	count_label.text = "[center]%s" % str(count)
