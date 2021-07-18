extends Node
class_name LightFlicker

enum FlickerType {
	NONE,
	SLOW,
	FAST
}

var light_source = null

onready var timer = get_node("Timer")

func _ready():
	light_source = get_parent()
	randomize()
	if light_source.flicker_type == FlickerType.NONE:
		return
	
	timer.wait_time = rand_wait_time()
	timer.connect("timeout", self, "on_timer_timeout")
	timer.start()
	print(light_source.flicker_type)

func rand_wait_time():
	
	var type = light_source.flicker_type
	
	match type:
		FlickerType.SLOW:
			return rand_range(2, 6)
		FlickerType.FAST:
			return rand_range(0.05, 0.3)

func on_timer_timeout():
	light_source.visible = not light_source.visible
	timer.wait_time = rand_wait_time()
	
