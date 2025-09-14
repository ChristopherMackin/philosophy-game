@tool
extends Node

class_name TimerHelper

func wait_for_seconds(seconds : float):
	await get_tree().create_timer(seconds).timeout
