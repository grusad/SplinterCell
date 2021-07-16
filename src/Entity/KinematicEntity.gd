extends KinematicBody
class_name KinematicEntity



var velocity = Vector3()
export (int) var acceleration = 10.0
export (int) var max_speed = 3.0


var nearby_light_sources = []
var stats : Stats = null
var friction = 10.0
var states = []
var direction = Vector3()
var strafe = Vector3()
var gravity_direction = Vector3.DOWN
var collision : KinematicCollision
var max_climb_angle = 0.6
var gravity = 0.98

func _init():
	add_to_group("KinematicEntity")
	stats = Stats.new()
	
func _physics_process(delta):
	for state in states:
		state.physics_process(delta)
	
	process_slope_movement(delta)
	process_light_visibility()

func process_light_visibility():
	var visibility = 0
	for source in nearby_light_sources:
		visibility += source.get_visibility(self)
	stats.light_visibility = clamp(visibility, 0, 1)

func process_slope_movement(delta):
	if !collision:
		velocity.y -= gravity
	elif Vector3.UP.dot(collision.normal) < max_climb_angle:
		
		velocity.y -= gravity

	if velocity.length() >= .1:
		collision = move_and_collide(velocity * delta)
	else:
		velocity = Vector3(0, velocity.y, 0)
	if collision:
		if Vector3.UP.dot(collision.normal) < .5:
			velocity.y += delta * gravity
			clamp(velocity.y, gravity, 9999)
			velocity = velocity.slide(collision.normal).normalized() * velocity.length()
		else:
			velocity = velocity
	
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
	
func damage(dmg):
	stats.health -= dmg
	if stats.health <= 0:
		die()
		
func die():
	queue_free()

