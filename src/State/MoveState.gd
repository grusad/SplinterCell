extends State



func enter_state(parent, previous_state = null, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	
	
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
	
	var camera_transform = parent.camera_transform
	var camera_rotation = camera_transform.basis.z
	var strafe = camera_transform.basis.x
	
	var dir = Vector3()
	dir += camera_rotation * movement_direction.z
	dir += strafe * movement_direction.x
	
	parent.apply_movement(dir, parent.acceleration, parent.max_speed, delta)
	
