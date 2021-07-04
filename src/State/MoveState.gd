extends State



func enter_state(parent, previous_state = null, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	#parent.play_animation("move_animation")
	
func exit_state():
	pass

func process_unhandled_input(event):
	pass
	
func physics_process(delta):
	var movement_direction : Vector3 = parent.get_input_direction()
	if movement_direction.length() <= 0:
		transition_to(parent.get_state("IdleState"))
	
	if Input.is_action_just_pressed("crouch"):
		parent.push_state(parent.get_state("CrouchState"))
		
	if Input.is_action_just_pressed("aim"):
		parent.push_state(parent.get_state("AimState"))
		
	parent.apply_movement(movement_direction, parent.acceleration, parent.max_speed, delta)
	
