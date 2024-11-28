extends Area2D

func play_attack_sword_animation():
	%AnimationPlayer.play("attacking")

func reset_animation():
	%AnimationPlayer.play("RESET")

func _ready():
	self.visible = false
	%CollisionShape2D.set_deferred("disabled", true)
