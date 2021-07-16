extends Spatial

onready var player = get_node("Player")
onready var world_env = get_node("WorldEnvironment")

func _ready():
	player.connect("toggle_night_vision", self, "on_night_vision_toggled")
	

func on_night_vision_toggled(on):
	if on:
		world_env.environment.ambient_light_energy = 100
	else:
		world_env.environment.ambient_light_energy = 1
	
