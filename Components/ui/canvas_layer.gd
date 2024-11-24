extends CanvasLayer

@onready var health_label = self.get_child(0).get_child(0).get_node("HealthLabel")

func _ready():
	var player_health_signal = get_parent().get_node("Player")
	player_health_signal.update_health.connect(update_health_label)

func update_health_label(hitpoint):
	health_label.text = str(hitpoint);
