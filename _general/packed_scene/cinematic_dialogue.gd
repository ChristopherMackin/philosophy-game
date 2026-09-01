@tool
extends Control

@export_multiline() var text: String:
	get():
		if !scrolling_text: return ""
		return scrolling_text.text
	set(val):
		if !scrolling_text: return
		scrolling_text.text = val
		
@export var scrolling_text: ScrollingText

@export var animation_player: AnimationPlayer

@export var seconds_before_close: float = 2

var anim_name: StringName = ""

var anim: Animation:
	get(): 
		if !animation_player: return
		
		return animation_player.get_animation(anim_name) if animation_player.has_animation(anim_name) else null

var node_path: NodePath:
	get():
		if !animation_player: return NodePath()
		
		var root_node: Node = animation_player.get_node(animation_player.root_node)
		var node_path: NodePath = root_node.get_path_to(self)
		return NodePath(str(node_path) + ":text")

func _process(delta):
	if !animation_player || !anim: 
		visible = false
		return
	
	var track_index = anim.find_track(node_path, Animation.TYPE_VALUE)
	
	if track_index == -1: 
		visible = false
		return
	
	var key_index = anim.track_find_key(track_index, animation_player.current_animation_position, Animation.FIND_MODE_NEAREST)
	
	if key_index == -1 || key_index + 1 >= anim.track_get_key_count(track_index): 
		visible = false
		return
	
	var key_val = anim.track_get_key_value(track_index, key_index)
	if key_val != anim.track_get_key_value(track_index, key_index + 1): 
		visible = false
		return
	
	var dialogue_start = anim.track_get_key_time(track_index, key_index)
	var dialogue_end = anim.track_get_key_time(track_index, key_index + 1)
	var dialogue_current_pos = animation_player.current_animation_position - dialogue_start
	
	if dialogue_current_pos < 0: 
		visible = false
		return
	
	var dialogue_length = dialogue_end - dialogue_start
	var normalized_dialogue_position = dialogue_current_pos / (dialogue_length - seconds_before_close)
	
	if !visible: visible = true
	if scrolling_text.text != key_val: scrolling_text.text = key_val
	scrolling_text.visible_ratio = normalized_dialogue_position

func _on_current_animation_changed(anim_name):
	if !anim_name: return
	self.anim_name = anim_name
