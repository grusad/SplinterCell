extends State

var patrol_path : Path = null
var targets = []
var chill 
var chill_timer = null
var path = []
var path_index = 0

func _ready():
	randomize()
	chill_timer = Timer.new()
	chill_timer.connect("timeout", self, "on_timer_timeout")
	chill_timer.one_shot = true
	add_child(chill_timer)
	

func enter_state(parent, previous_state, parameters = {}):

	.enter_state(parent, previous_state, parameters)	
	parent.get_vision().connect("player_alert", self, "on_player_alert")
	parent.play_animation("idle_animation")
	
	patrol_path = parent.get_node_or_null("Path")
	if not patrol_path:
		transition_to(parent.get_node("IdleState"))
		
	for i in patrol_path.curve.get_point_count():
		targets.push_back(parent.to_global(patrol_path.curve.get_point_position(i)))
	
	find_path()
	
	
func exit_state():
	parent.get_vision().disconnect("player_alert", self, "on_player_alert")
	chill_timer = 0
	chill = false
	path_index = 0

func physics_process(delta):
	
	if not chill:
		parent.play_animation("walk_animation")
		path = parent.move(path, delta, null, true)
		
		if path.empty():
			chill = true
			chill_timer.wait_time = rand_range(2, 8)
			chill_timer.start()
			
			
	else:
		parent.apply_friction(5, delta)
		parent.play_animation("idle_animation")
	
func find_path():
	path = parent.navigation.get_simple_path(parent.global_transform.origin, targets[path_index], true)

func on_player_alert(player):
	transition_to(parent.get_state("CombatState"), {"target": player, "update_path_time": 1})

func on_timer_timeout():
	chill = false
	path_index += 1
	if path_index >= targets.size():
		path_index = 0
	
	find_path()
