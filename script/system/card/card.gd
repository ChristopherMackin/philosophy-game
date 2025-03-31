extends Object

class_name Card

var collection : CardCollection

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
var has_token_base : bool:
	get: return _base.token_data != null
var has_token: bool:
	get: return _token != null

var _on_play_card_actions: Array[CardAction] = []
var _on_draw_card_actions: Array[CardAction] = []
var _on_discard_card_actions: Array[CardAction] = []
var _on_banish_card_actions: Array[CardAction] = []
var _on_turn_start_card_actions: Array[CardAction] = []
var _on_turn_end_card_actions: Array[CardAction] = []
var _on_hold_start_card_actions: Array[CardAction] = []
var _on_hold_stay_card_actions: Array[CardAction] = []
var _on_hold_end_card_actions: Array[CardAction] = []

var cost_modifiers : Array[CardCostModifier] = []
var manager : DebateManager

func on_play(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_play_card_actions, Const.CardActionType.ON_PLAY, contestant, manager)
func on_draw(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_draw_card_actions, Const.CardActionType.ON_DRAW, contestant, manager)
func on_discard(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_discard_card_actions, Const.CardActionType.ON_DISCARD, contestant, manager)
func on_banish(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_banish_card_actions, Const.CardActionType.ON_BANISH, contestant, manager)
func on_turn_start(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_turn_start_card_actions, Const.CardActionType.ON_TURN_START, contestant, manager)
func on_turn_end(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_turn_end_card_actions, Const.CardActionType.ON_TURN_END, contestant, manager)
func on_hold_start(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_start_card_actions, Const.CardActionType.ON_HOLD_START, contestant, manager)
func on_hold_stay(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_stay_card_actions, Const.CardActionType.ON_HOLD_STAY, contestant, manager)
func on_hold_end(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_end_card_actions, Const.CardActionType.ON_HOLD_END, contestant, manager)

func _invoke_actions(actions: Array[CardAction], action_type: Const.CardActionType, contestant: Contestant, manager: DebateManager):
	for action : CardAction in actions:
		if !await action.invoke(self, contestant, manager): break
	
	for sub : DebateSubscriber in manager.subscriber_array: await sub.on_actions_invoked(self, action_type, contestant)
	manager.blackboard.expire(Const.ExpirationToken.ON_ACTION_END)

var cost : int :
	get:
		var ret = base_cost
	
		cost_modifiers.sort_custom(func(a, b): return a.priority > b.priority)
	
		for modifier in cost_modifiers:
			ret = modifier.modify_cost(ret, manager)
	
		return ret if ret >= 0 else 0

func _init(base: CardBase, manager : DebateManager):	
	suit = base.suit
	
	_base = base
	
	_on_play_card_actions.assign(Util.deep_copy_resource_array(base.on_play_card_actions))
	_on_discard_card_actions.assign(Util.deep_copy_resource_array(base.on_discard_card_actions))
	_on_banish_card_actions.assign(Util.deep_copy_resource_array(base.on_banish_card_actions))
	_on_turn_start_card_actions.assign(Util.deep_copy_resource_array(base.on_turn_start_card_actions))
	_on_turn_end_card_actions.assign(Util.deep_copy_resource_array(base.on_turn_end_card_actions))
	_on_hold_start_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_start_card_actions))
	_on_hold_stay_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_stay_card_actions))
	_on_hold_end_card_actions.assign(Util.deep_copy_resource_array(base.on_hold_end_card_actions))
	cost_modifiers.assign(Util.deep_copy_resource_array(base.cost_modifiers))
	
	self.manager = manager

func generate_token():
	_token = Token.new(_base.token_data) if _base.token_data else null

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
