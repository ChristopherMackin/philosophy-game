extends Sprite3D

class_name Card3d

@export var card_parent: Node
@export var animation_player: AnimationPlayer

func init(card: Card, card_ui_packed_scene: PackedScene):	
	var card_ui : CardUi = card_ui_packed_scene.instantiate() as CardUi
	card_parent.add_child(card_ui)
	
	card_ui.card = card
	card_ui.set_anchors_preset(Control.PRESET_CENTER, true)
	
	#animation_player.play("card_enter")
	#await animation_player.animation_finished
