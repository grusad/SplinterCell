extends KinematicEntity


onready var upper_collider = $UpperCollider
onready var camera = $UpperCollider/Camera

var MOUSE_SENSITIVITY = 0.2
var camera_transform : Transform = Transform()

func _ready():
	add_to_group("Player")
	get_node("HUD/Debug").player = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	var initial_state = get_state("IdleState")
	initial_state.enter_state(self, null)
	push_state(initial_state)
	

func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func get_input_direction():
	
	return Vector3(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0,
			Input.get_action_strength("back") - Input.get_action_strength("forward")
		).normalized()

func _unhandled_input(event):
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		upper_collider.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = upper_collider.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		upper_collider.rotation_degrees = camera_rot
		
		var cam_xform = camera.get_global_transform()
		self.camera_transform = cam_xform
		
		
func get_weapon_texture():
	return get_node("PlayerWeaponTexture")
	
func play_animation(animation):
	var animation_player = get_node("AnimationPlayer")
	
	if animation_player.current_animation == animation:
		return
		
	if animation != "aim_animation" and has_state("AimState"):
		return
	
	animation_player.play(animation)
	
func get_aim():
	return get_node("UpperCollider/Camera/Aim")
	
	


