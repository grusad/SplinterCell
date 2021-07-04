extends RayCast

var target = null

func _physics_process(delta):
	if is_colliding():
		target = get_collider()
	else:
		target = null
