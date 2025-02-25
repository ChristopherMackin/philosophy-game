extends Resource

class_name Brain

var contestant : Contestant

func select(_request : SelectionRequest) -> SelectionResponse:
	return SelectionResponse.new()

func view(_options : Array, _what : String, _type : String):
	pass
