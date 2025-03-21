extends Object

class_name Card

var _base : CardBase

var _token : Token

var suit : Suit

var base_cost : int:
	get: return _base.base_cost
var title : String:
	get: return _base.title
var description : String:
	get: return _base.description
var token_artwork : Texture2D:
	get: return _token.artwork if _token else null

var on_play_card_actions : Array[CardAction]
var on_discard_card_actions : Array[CardAction]
var on_banish_card_actions : Array[CardAction]
var on_turn_start_card_actions : Array[CardAction]
var on_turn_end_card_actions : Array[CardAction]
var on_hold_start_card_actions : Array[CardAction]
var on_hold_stay_card_actions : Array[CardAction]
var on_hold_end_card_actions : Array[CardAction]
var cost_modifiers : Array[CardCostModifier]
var manager : DebateManager

var cost : int :
	get:
		var ret = base_cost
	
		cost_modifiers.sort_custom(func(a, b): return a.priority > b.priority)
	
		for modifier in cost_modifiers:
			ret = modifier.modify_cost(ret, manager)
	
		return ret if ret >= 0 else 0

func _init(base: CardBase, manager : DebateManager):
	_token = Token.new(base.token_data) if base.token_data else null
	
	suit = base.suit
	
	_base = base
	
	on_play_card_actions.assign(Util.deep_copy_resource_array(base.on_play_card_actions))
	on_discard_card_actions.assign(Util.deep_copy_resource_array(base.on_discard_card_actions))
	on_banish_card_actions.assign(Util.deep_copy_resource_array(base.on_banish_card_actions))
	on_turn_start_card_actions.assign(Util.deep_copy_resource_array(base.on_turn_start_card_actions))
	on_turn_end_card_actions.assign(Util.deep_copy_resource_array(base.on_turn_end_card_actions))
	on_hold_start_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_start_card_actions))
	on_hold_stay_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_stay_card_actions))
	on_hold_end_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_end_card_actions))
	cost_modifiers.assign(Util.deep_copy_resource_array(base.cost_modifiers))
	
	self.manager = manager

func dupliate_token() -> Token:
	return _token.duplicate()

func pop_token() -> Token:
	if !_token: return null
	
	var ret = _token
	_token = null
	return ret

func destroy_token():
	_token = null

func replace_token(token: Token):
	_token = token
