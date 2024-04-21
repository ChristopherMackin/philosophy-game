@tool
extends Resource

class_name DebateSettings

@export var topic_array : Array[Topic]

@export var win_amount : int = 5

enum SuitRelationship {
	SAME,
	OPPOSING,
	OFF_TOPIC,
	NONE,
}

func has_suit(suit : Suit) -> bool:
	for topic : Topic in topic_array:
		if topic.has_suit(suit):
			return true
	
	return false

func get_topic_index(suit : Suit) -> int:
	var index = 0
	
	for topic : Topic in topic_array:
		if topic.has_suit(suit):
			return index
		
		index += 1
	
	return -1

func get_topic(suit : Suit) -> Topic:
	var index = get_topic_index(suit)
	
	if index == -1:
		return null
	
	return topic_array[index]

func conflicting(suit_1 : Suit, suit_2 : Suit) -> bool:
	for topic : Topic in topic_array:
		if topic.has_suit(suit_1) and topic.has_suit(suit_2) and suit_1 != suit_2:
			return true
		
	return false

func get_suit_relationship(suit_1 : Suit, suit_2 : Suit) -> SuitRelationship:
	if suit_1 == suit_2:
		return SuitRelationship.SAME
	elif (conflicting(suit_1, suit_2)):
		return SuitRelationship.OPPOSING
	elif has_suit(suit_1) and has_suit(suit_2):
		return SuitRelationship.OFF_TOPIC
	
	return SuitRelationship.NONE
