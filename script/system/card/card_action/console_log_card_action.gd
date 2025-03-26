extends CardAction

class_name ConsoleLogCardAction

@export_multiline var text : String

func invoke(card : Card, player : Contestant, manager : DebateManager):
	print(text)
	return true
