extends Node

class_name EnergyPool

@onready var amount_label : RichTextLabel = $AmountLabel

func set_energy(amount : int):
	amount_label.text = "[center]%s" % str(amount)
