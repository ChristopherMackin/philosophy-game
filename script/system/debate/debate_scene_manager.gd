extends DebateSubscriber

@export var player : Character
@export var computer : Character
@export var debate_settings : DebateSettings

@export var hand_ui : HandUI

var is_animation_locked := false

func _ready():
	super._ready()
	
	manager.init.call_deferred(player, computer, debate_settings)

func on_debate_start():
	pass
	
func on_player_change(contestant : Contestant):
	print("%s's turn" % contestant.name)
	hand_ui.update_hand(manager.player.hand)
	await GlobalTimer.wait_for_seconds(1)
	
func on_top_played(top: Top, active_contestant : Contestant):
	print("%s played %s" % [active_contestant.name, top.data.title])
	if active_contestant.character == player:
		hand_ui.remove_card(top)
	await GlobalTimer.wait_for_seconds(1)

func on_score_updated(pose_score_dictionary : Dictionary):
	pass

func on_lines_cleared(count : int):
	pass

func on_debate_finished():
	print("Debate Finished")
