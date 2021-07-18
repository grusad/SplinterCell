extends Spatial

onready var player = get_node("Player")
onready var world_env = get_node("WorldEnvironment")

func _ready():
	Globals.connect("light_factor", self, "on_light_factor_changed")
	

func on_light_factor_changed(amount):
	if amount == 1:
		world_env.environment.ambient_light_energy = amount
	else:
		world_env.environment.ambient_light_energy = amount * 10
	
