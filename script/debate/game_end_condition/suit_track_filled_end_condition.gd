extends GameEndCondition

class_name SuitTrackFilledEndCondition

func check_condition(manager: DebateManager):
	for value in manager.suit_track_dictionary.values():
		if value.size() >= manager.debate_settings.slots:
			return true
	
	return false
