extends Node

class_name CounterUi

signal on_counter_updated(count: int)

@export var rich_text: RichTextLabel
var amount: int

func update_amount(amount : int):
	self.amount = amount
	rich_text.text = str(amount)
	on_counter_updated.emit(amount)
