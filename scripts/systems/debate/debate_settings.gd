extends Resource

class_name DebateSettings

@export var pos_x_suit : Suit
@export var neg_x_suit : Suit

@export var pos_y_suit : Suit
@export var neg_y_suit : Suit

@export var win_amount : int = 5

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

func get_opposing_suit(suit : Suit):
	if suit == pos_x_suit:
		return neg_x_suit
	
	elif suit == neg_x_suit:
		return pos_x_suit
	
	elif suit == pos_y_suit:
		return neg_y_suit
	
	elif suit == neg_y_suit:
		return pos_y_suit
	
	else:
		return null
	
