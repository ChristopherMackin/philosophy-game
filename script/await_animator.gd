extends AnimationPlayer

class_name AwaitAnimator

signal on_finish
signal on_begin

func play_await(name : String):
	super.play(name)
	await on_finish

func play_reverse_await(name : String):
	super.play_backwards(name)
	await on_begin
