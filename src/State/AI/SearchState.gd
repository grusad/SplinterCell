extends State

onready var navigation = get_tree().root.get_node("Test/Navigation")

const MAX_ATTEMPS = 5

var path = []
var timer = null
var attemps = 0


func _ready():
	randomize()
	timer = Timer.new()
	timer.wait_time = rand_range(2, 8)
	timer.connect("timeout", self, "on_timer_timeout")
	add_child(timer)
	
func enter_state(parent, previous_state, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	
	parent.get_vision().connect("player_alert", self, "on_player_alert")
	parent.play_animation("aim_animation")
	
	find_random_target()
	
	
func exit_state():
	parent.get_vision().disconnect("player_alert", self, "on_player_alert")
	timer.stop()
	attemps = 0
	path = []

func physics_process(delta):
	if not path.empty():
		path = parent.move(path, path[0], delta)
		parent.play_animation("aim_walk_animation")
	else:
		parent.play_animation("aim_animation")
		parent.apply_friction(5, delta)
		if timer.is_stopped():
			timer.start()
	
func find_random_target():
	var radius = 4
	var random_target = Vector3(rand_range(-radius, radius), parent.global_transform.origin.y, rand_range(-radius, radius))
	var target = navigation.get_closest_point(random_target) + parent.global_transform.origin
	path = navigation.get_simple_path(parent.global_transform.origin, target, true)

func on_player_alert(player):
	transition_to(parent.get_state("CombatState"), {"target": player, "update_path_time": 1})
	

func on_timer_timeout():
	if attemps > MAX_ATTEMPS:
		transition_to(parent.get_state("IdleState"))
	else:
		timer.stop()
		timer.wait_time = rand_range(2, 8)
		find_random_target()
		attemps += 1
	
