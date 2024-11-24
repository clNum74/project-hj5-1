extends Area2D

@export var hitpoint := 3
@onready var spawn_shape = $SpawnArea/SpawnShape

@onready var area_size : Vector2 = spawn_shape.shape.size
@onready var spawn_area_max := Vector2(area_size.x/2, area_size.y/2)

func _ready():
	pass

func take_damage():
	hitpoint -= 1
	#%AnimationPlayer.play("hurt")
	if hitpoint == 0:
		queue_free()

func _on_timer_timeout():
	var spawn_pos_x = self.global_position.x + spawn_area_max.x - (fmod(randi(), area_size.x))
	var spawn_pos_y = self.global_position.y + spawn_area_max.y - (fmod(randi(), area_size.y))
	const RAT = preload("res://Components/enemy/enemy_rat.tscn")
	var new_rat = RAT.instantiate()
	get_parent().add_child(new_rat)
	new_rat.global_position = Vector2(spawn_pos_x, spawn_pos_y)
