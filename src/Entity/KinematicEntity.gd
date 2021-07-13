extends KinematicBody
class_name KinematicEntity



var velocity = Vector3()
export (int) var acceleration = 10.0
export (int) var max_speed = 3.0
var friction = 10.0
var states = []
var direction = Vector3()
var strafe = Vector3()

	
func _physics_process(delta):
	for state in states:
		state.physics_process(delta)
	
	if not is_on_floor():
		velocity.y -= 0.5
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, deg2rad(70))

func push_state(state, old_state = null, parameters = {}):
	if has_state(state):
		return
	states.push_back(state)
	state.enter_state(self, old_state, parameters)
	state.post_add_event()
	
func has_state(state):
	if typeof(state) == TYPE_STRING:
		return states.has(get_state(state))
	return states.has(state)
	
	
func get_state(state_name):
	return get_node_or_null("States/" + state_name)


func apply_movement(movement_direction, acceleration, max_speed, delta):
	velocity = lerp(velocity, movement_direction * max_speed, acceleration * delta)
	
func apply_force(direction, force):
	velocity = direction * force
	
func apply_friction(friction, delta):
	velocity = lerp(velocity, Vector3.ZERO, friction * delta)
	
func stop_movement():
	velocity = Vector3.ZERO

func remove_state(state):
	state.exit_state()
	states.erase(state)
	state.post_remove_event()
	


