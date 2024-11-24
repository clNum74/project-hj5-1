extends CharacterBody2D

var speed = 40
var motion = Vector2.ZERO
var player = null
var idle_movement_allowed = false
var random_rat_vector2 = Vector2.ZERO
var health = 3

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * speed
	elif idle_movement_allowed == true:
		velocity = position.direction_to(random_rat_vector2) * (speed - 10)
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player = null


func _on_timer_timeout():
	random_rat_vector2 = Vector2(position.x + (randf_range(-1, 1) * 100 + 30), position.y + (randf_range(-1, 1) * 100 + 30))
	if idle_movement_allowed == true:
		idle_movement_allowed = false
		velocity = Vector2.ZERO
	else:
		idle_movement_allowed = true

func take_damage():
	health -= 1
	%AnimationPlayer.play("hurt")

	if health == 0:
		queue_free()
