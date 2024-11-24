extends Area2D

var travelled_distance = 0
var initial_direction: Vector2


func _ready():
	self.set_physics_process(false)

func set_direction(direction: Vector2):
	initial_direction = direction
	self.set_physics_process(true)

func _physics_process(delta):
	const SPEED = 150
	const RANGE = 150
	
	position += initial_direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

## take_damage for player
func _on_body_entered(body):
	queue_free()
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage()
