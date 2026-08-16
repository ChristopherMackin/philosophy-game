extends Sprite3D

class_name Card3d

@export var card_parent: Node
@export var animation_player: AnimationPlayer

func init(card: Card, card_gui_packed_scene: PackedScene):	
	var card_gui : CardGUI = card_gui_packed_scene.instantiate() as CardGUI
	card_parent.add_child(card_gui)
	
	card_gui.card = card
	card_gui.pivot_offset = Vector2.ZERO
	card_gui.position = Vector2.ZERO
		
	#animation_player.play("card_enter")
	#await animation_player.animation_finished
