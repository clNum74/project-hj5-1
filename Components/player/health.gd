extends Node

@export var hitpoint : int = 6

func take_damage():
	hitpoint -= 1
	%AnimationPlayer.play("hurt")
	if hitpoint == 0:
		queue_free()
