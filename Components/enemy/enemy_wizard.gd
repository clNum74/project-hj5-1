extends CharacterBody2D

@export var speed = 80
@export var hitpoint = 3

var player = null
var idle_movement_allowed = false
var attack_on_cooldown: bool = false

func take_damage():
	hitpoint -= 1
	#%AnimationPlayer.play("hurt")
	if hitpoint == 0:
		queue_free() 

func attack():
	var player_position
	if is_instance_valid(player):
		player_position = player.global_position
	else:
		return
	var scythe_direction = self.position.direction_to(player_position)
	
	const SCYTHE = preload("res://Components/weapon/scythe.tscn")
	var new_scythe = SCYTHE.instantiate()
	new_scythe.global_position = self.global_position
	self.get_parent().add_child(new_scythe)
	
	new_scythe.set_direction(scythe_direction)
	%AttackCooldown.start()
	attack_on_cooldown = true

func _physics_process(delta):
	#velocity = Vector2.ZERO
	if player and attack_on_cooldown == false:
		attack()
		#velocity = position.direction_to(player.position) * speed
	#elif idle_movement_allowed == true:
		#velocity = position.direction_to(random_rat_vector2) * (speed - 10)
	#move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body


func _on_attack_cooldown_timeout():
	attack_on_cooldown = false
