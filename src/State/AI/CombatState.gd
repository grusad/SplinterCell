extends State

onready var navigation = get_tree().root.get_node("Test/Navigation")

var target = null
var vision = null
var timer = null
var path = []
var target_last_seen = Vector3()

func _ready():
	randomize()
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "find_path")
	timer.wait_time = 1

func enter_state(parent, previous_state, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	target = parameters.get("target")
	vision = parent.get_vision()
	target_last_seen = target.global_transform.origin
	timer.start()
	find_path()
	
	parent.play_animation("aim_animation")
	
func exit_state():
	target = null
	timer.stop()
	target_last_seen = Vector3()

func physics_process(delta):
	if vision.see_player():
		target_last_seen = target.global_transform.origin
		
	if vision.can_fire():
		parent.play_animation("aim_animation")
		parent.apply_friction(5, delta)
		parent.rotate_towards(target_last_seen)
	else:
		path = parent.move(path, delta, target_last_seen)
		parent.play_animation("aim_walk_animation")
	
	if path.empty() and not vision.see_player():
		transition_to(parent.get_state("SearchState"))


func find_path():
	path = navigation.get_simple_path(parent.global_transform.origin, target_last_seen, true)
	
		
