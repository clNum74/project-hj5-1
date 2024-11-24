extends Area2D

var travelled_distance = 0

func play_throw_knife_animation():
	%AnimationPlayer.play("Throw Knife")

func reset_animation():
	%AnimationPlayer.play("RESET")

func _physics_process(delta):
	const SPEED = 450
	const RANGE = 90
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

## take_damage for enemy (characterBody2D)
func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()

## take_damage for spawner (area)
func _on_area_entered(area):
	queue_free()
	if area.has_method("take_damage"):
		area.take_damage()
