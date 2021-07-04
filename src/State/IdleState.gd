extends State


func enter_state(parent, previous_state = null, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	parent.play_animation("idle_animation")
	
func exit_state():
	pass

func process_unhandled_input(event):
	pass
	
func physics_process(delta):
	parent.apply_friction(parent.friction, delta)
	if Input.is_action_just_pressed("crouch"):
		parent.push_state(parent.get_state("CrouchState"))
	if parent.get_input_direction().length() > 0:
		transition_to(parent.get_state("MoveState"))
	if Input.is_action_just_pressed("aim"):
		parent.push_state(parent.get_state("AimState"))
	
