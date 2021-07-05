extends Spatial

onready var timer = get_node("Timer")

func _ready():
	timer.wait_time = 2
	timer.connect("timeout", self, "on_timer_timeout")
	
	
func on_timer_timeout():
	queue_free()	
	
func start(hit_data):
	
	var object = hit_data.hit_object
	var position = hit_data.hit_position
	var normal = hit_data.hit_normal
	
	global_transform.origin = position
	
	
	if object.is_in_group("Enemy"):
		$Blood.emitting = true
	
	else:
		$Regular.emitting = true
	
	
	timer.start()
	
	
	
