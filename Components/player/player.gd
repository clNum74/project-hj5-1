class_name Player extends CharacterBody2D

enum Move_States {DISABLED, IDLE, WALK}
enum Attack_States {DISABLED, FREE, PREATTACK, ATTACKING}

var move_state : Move_States = Move_States.DISABLED : set = set_move_state
var attack_state : Attack_States = Attack_States.FREE : set = set_attack_state

signal update_health

@onready var sprite2d = $Sprite2D
@onready var attackCooldown = $AttackCooldown
@onready var animation_player = %AnimationPlayer

@export var speed := 160
@export var slow_effect := 0
@export var hitpoint : int = 6

func _ready():
	move_state = Move_States.IDLE
	update_health.emit(hitpoint)
	#print(Move_States.keys())
	#print(Move_States.find_key(attack_state))
	#print(event.as_text())


# Run current move_state
func run_move_state(move_state: int) -> void:
	## IDLE STATE
	if move_state == Move_States.IDLE:
		pass
	
	## WALK STATE
	elif move_state == Move_States.WALK:
		# Detect current direction in Vector2 e.g. left = (-1, 0), down = (0, 1)
		var direction = Input.get_vector("move_left","move_right","move_up","move_down")
		
		# Flip sprite based on direction
		if velocity.x < 0:
			sprite2d.flip_h = true
		elif velocity.x > 0:
			sprite2d.flip_h = false
		
		velocity = direction * (speed - slow_effect)
		move_and_slide()


func run_attack_state(attack_state: int) -> void:
	## ATTACKING STATE
	if attack_state == Attack_States.ATTACKING:
		if attackCooldown.is_stopped():
			attackCooldown.start()
			throw_knife()


# Handle STATES transition and animation
func set_move_state(new_state: int) -> void:
	# Set Move Animations
	var previous_state := move_state
	move_state = new_state
	if previous_state == Move_States.DISABLED:
		if move_state == Move_States.IDLE:
			animation_player.play("idle")
	elif previous_state == Move_States.IDLE:
		if move_state == Move_States.WALK:
			animation_player.play("walk")
	elif previous_state == Move_States.WALK:
		if move_state == Move_States.IDLE:
			animation_player.play("idle")

func set_attack_state(new_state: int) -> void:
	# Set Attack_States Animations
	var previous_state := attack_state
	attack_state = new_state
	if previous_state == Attack_States.FREE:
		if attack_state == Attack_States.ATTACKING:
			slow_effect = 40
	elif previous_state == Attack_States.ATTACKING:
		if attack_state == Attack_States.FREE:
			slow_effect = 0

func throw_knife():
	const KNIFE = preload("res://Components/weapon/knife.tscn")
	var new_knife = KNIFE.instantiate()
	%KnifePoint.add_child(new_knife)
	new_knife.set_physics_process(false)
	if sprite2d.flip_h == false:
		new_knife.global_position
	else:
		new_knife.global_position = Vector2(%KnifePoint.global_position.x - (%KnifePoint.position.x * 2), %KnifePoint.global_position.y)
		new_knife.rotate(135.1)
	new_knife.play_throw_knife_animation()


# flip sprite depending on direction
func change_sprite_direction(playerDirection):
	if playerDirection.x < 0:
		sprite2d.flip_h = true
	else:
		sprite2d.flip_h = false

func take_damage():
	#emit_signal("update_health")
	hitpoint -= 1
	update_health.emit(hitpoint)
	%AnimationPlayer.play("hurt")
	if hitpoint == 0:
		queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("ranged_attack"):
		if attack_state != Attack_States.ATTACKING:
			attack_state = Attack_States.ATTACKING
			return
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("move_down") or event.is_action_pressed("move_up"):
		if move_state != Move_States.WALK:
			move_state = Move_States.WALK
			return


func _physics_process(delta):
	## PRINT GENERAL HINT
	#print(Move_States.keys()[move_state])
	#print(velocity)
	#print ("move_state:", Move_States.keys()[move_state], " childCount:", %KnifePoint.get_child_count())
	## END
	
	
	# Check player movement
	if not Input.is_anything_pressed() and move_state != Move_States.IDLE:
		move_state = Move_States.IDLE

	# Run move and attack states
	run_move_state(move_state)
	run_attack_state(attack_state)


func _on_attack_cooldown_timeout():
	if attack_state != Attack_States.FREE:
		attack_state = Attack_States.FREE
