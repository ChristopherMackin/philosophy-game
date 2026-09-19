extends CardArrayFilter

class_name HasTokenCardArrayFilter

@export_enum("On Card", "On Base") var token_location: int
@export var has_token: bool = true

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	match token_location:
		0:
			return card_array.filter(func(c: Card): return c.has_token == has_token)
		_:
			return card_array.filter(func(c: Card): return c.has_token_base == has_token)
