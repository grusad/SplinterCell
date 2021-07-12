extends KinematicEntity


export (String, "IdleState", "PatrolState") var initial_state = "IdleState"

onready var sprite = $Sprite3D
onready var vision = $Vision


func _ready():
	add_to_group("Enemy")
	push_state(get_state(initial_state), null)
	max_speed = 1

func _physics_process(delta):
	._physics_process(delta)
	
	if vision.player_in_front:
		sprite.modulate = Color.white
	else:
		sprite.modulate = Color.black
	
func get_vision():
	return vision

func play_animation(animation):
	var animation_player = get_node("AnimationPlayer")
	
	if animation_player.current_animation == animation:
		return
		
	if animation != "aim_animation" and has_state("AimState"):
		return
	
	animation_player.play(animation)

func rotate_towards(target):
	look_at(target, Vector3.UP)
	rotation_degrees.y += 180
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	
func move(path, delta, look_at = null, break_move = false):
	if not path.empty():
		if global_transform.origin.distance_to(path[0]) < 0.5:
			path.remove(0)
			if break_move:
				return path
	
	if not path.empty():
		if not look_at:
			look_at = path[0]
		rotate_towards(look_at)

		var direction = (path[0] - global_transform.origin).normalized()
		
		apply_movement(direction, acceleration, max_speed, delta)
	else:
		apply_friction(5, delta)
	
	return path
