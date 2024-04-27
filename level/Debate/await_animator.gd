extends AnimationPlayer

class_name AwaitAnimator

signal finished

func play_await(name : String):
	super.play(name)
	await finished
