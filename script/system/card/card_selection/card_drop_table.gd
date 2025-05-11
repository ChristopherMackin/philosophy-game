@tool
extends Resource

class_name CardDropTable

@export var cards: Array[CardBaseDropRate]

func calculate_weighted_list() -> Array[int]:
	var _weighted_list: Array[int] = []
	var index:= 0
	for cbw in cards:
		for i in cbw.weight:
			_weighted_list.append(index)
		index += 1
	
	return _weighted_list

func get_random_card():
	var weighted_list = calculate_weighted_list()
	if weighted_list.size() <= 0: return
	
	var index = weighted_list[randi_range(0, weighted_list.size() -1)]
	return cards[index].card_base
