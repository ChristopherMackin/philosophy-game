extends Object

class_name Card

signal card_updated(card: Card)

enum Tag {
	SUPPORT,
	ATTACK,
	SELF,
	OPPONENT,
	ALTER
}

var collection : CardCollection

var _base : CardBase
var base : CardBase:
	get(): return _base

var token_data: TokenData:
	get():
		if ! _base: return null
		return _base.token_data

var base_token_counter: int = 0:
	set(val):
		base_token_counter = val if val > 0 else 0
		card_updated.emit()
var token_counter: int:
	get():
		return base_token_counter

var suit : Suit:
	set(val):
		if val == suit: return
		suit = val
		card_updated.emit(self)

var base_cost : int:
	get: return _base.base_cost
var title : String:
	get: return _base.title
var description : String:
	get: return _base.description
var token_artwork : Texture2D:
	get: return token_data.artwork if token_data else null

var _on_play_card_actions: Array[CardAction] = []
var _on_draw_card_actions: Array[CardAction] = []
var _on_discard_card_actions: Array[CardAction] = []
var _on_banish_card_actions: Array[CardAction] = []
var _on_turn_start_card_actions: Array[CardAction] = []
var _on_turn_end_card_actions: Array[CardAction] = []
var _on_hold_start_card_actions: Array[CardAction] = []
var _on_hold_stay_card_actions: Array[CardAction] = []
var _on_hold_end_card_actions: Array[CardAction] = []

var sort_func = func(a, b):
	return a.priority < b.priority

var status_effects:= SortedArray.new(sort_func)
var cost_status_effects:= SortedArray.new(sort_func)
var condition_status_effects:= SortedArray.new(sort_func)

var manager : DebateManager

var tags: Array[Tag]

func on_play(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_play_card_actions, CardAction.Type.ON_PLAY, contestant, manager)
func on_draw(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_draw_card_actions, CardAction.Type.ON_DRAW, contestant, manager)
func on_discard(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_discard_card_actions, CardAction.Type.ON_DISCARD, contestant, manager)
func on_banish(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_banish_card_actions, CardAction.Type.ON_BANISH, contestant, manager)
func on_turn_start(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_turn_start_card_actions, CardAction.Type.ON_TURN_START, contestant, manager)
func on_turn_end(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_turn_end_card_actions, CardAction.Type.ON_TURN_END, contestant, manager)
func on_hold_start(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_start_card_actions, CardAction.Type.ON_HOLD_START, contestant, manager)
func on_hold_stay(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_stay_card_actions, CardAction.Type.ON_HOLD_STAY, contestant, manager)
func on_hold_end(contestant: Contestant, manager: DebateManager):
	await _invoke_actions(_on_hold_end_card_actions, CardAction.Type.ON_HOLD_END, contestant, manager)

func _invoke_actions(actions: Array[CardAction], action_type: CardAction.Type, contestant: Contestant, manager: DebateManager):
	if actions.size() <= 0: return
	
	for action : CardAction in actions:
		var can_act := true
		for condition_effect in condition_status_effects.values:
			if ! condition_effect.check(action):
				can_act = false
				break
		if !can_act: continue
		
		if !await action.invoke(self, contestant, manager): break
	
	for sub in manager.subscribers: await sub.on_actions_invoked(self, action_type, contestant)

var cost : int :
	get:
		var ret = base_cost
		
		for effect in cost_status_effects.values:
			ret = effect.modify_cost(ret, manager)
	
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
	
	for effect: CardStatusEffect in Util.deep_copy_resource_array(base.card_status_effects):
		effect.apply(self)
	
	status_effects.array_updated.connect(func(): card_updated.emit(self))
	
	reset_token_counter()
	
	self.manager = manager
	
	tags = base.tags

func duplicate(keep_status_effects: bool = false):
	var card = Card.new(_base, manager)
	if keep_status_effects:
		for effect: CardStatusEffect in status_effects.values:
			effect.duplicate().apply(card)
	return card

func equals(card: Card) -> bool:
	if card.status_effects.size() == status_effects.size():
		for i in status_effects.size():
			if card.status_effects.values[i] != status_effects.values[i]: return false
	else:
		return false
	
	return card.base == _base && \
	card.suit == suit

func reset_token_counter():
	if !_base: return
	base_token_counter = _base.starting_token_counter
