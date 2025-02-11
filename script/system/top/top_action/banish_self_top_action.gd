extends TopAction

class_name BanishSelfTopAction

func invoke(top : Top, player : Contestant, manager : DebateManager):
	player.remove_from_deck(top)
