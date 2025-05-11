extends Control

class_name SceneTransition

signal transition_out_started
signal _transition_out_finished
signal transition_in_started
signal _transition_in_finished

func _ready():
	start_transition_out()

func start_transition_out():
	transition_out_started.emit()
	await _transition_out_finished

func signal_transition_out_finished():
	_transition_out_finished.emit()

func start_transition_in():
	transition_in_started.emit()
	await _transition_in_finished

func signal_transition_in_finished():
	_transition_in_finished.emit()
