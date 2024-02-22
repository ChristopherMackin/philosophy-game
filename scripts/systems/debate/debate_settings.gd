extends Resource

class_name DebateSettings

@export var pos_x_suit : Suit
@export var neg_x_suit : Suit

@export var pos_y_suit : Suit
@export var neg_y_suit : Suit

@export var win_amount : int = 5

enum SuitRelationship {
	SAME,
	OPPOSING,
	COMPLEMENTARY,
	NONE,
}

func get_suit_vector(suit : Suit):
	if suit == pos_x_suit:
		return Vector2(1, 0)
		
	elif suit == neg_x_suit:
		return Vector2(-1, 0)
		
	elif suit == pos_y_suit:
		return Vector2(0, 1)
		
	elif suit == neg_y_suit:
		return Vector2(0, -1)
		
	else:
		return Vector2(0, 0)

func has_suit(suit : Suit) -> bool:
	match suit:
		pos_x_suit, neg_x_suit, pos_y_suit, neg_y_suit:
			return true
		_:
			return false

func get_suit_relationship(suit_1 : Suit, suit_2 : Suit) -> SuitRelationship:
	if suit_1 == suit_2:
		return SuitRelationship.SAME
	elif (get_suit_vector(suit_1) + get_suit_vector(suit_2)).length() == 0:
		return SuitRelationship.OPPOSING
	elif has_suit(suit_1) and has_suit(suit_2):
		return SuitRelationship.COMPLEMENTARY
	
	return SuitRelationship.NONE
