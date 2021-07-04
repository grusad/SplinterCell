extends State

var current_max_speed = 0
var tween : Tween = null
var upper_collider = null
var crouch_length = 0.3

var stand_level = null
var crouch_level = null

func _ready():
	tween = Tween.new()
	add_child(tween)

func enter_state(parent, previous_state = null, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	current_max_speed = parent.max_speed
	parent.max_speed *= 0.5
	upper_collider = parent.get_node("UpperCollider")
	
	if not stand_level:
		stand_level = parent.upper_collider.translation.y
		crouch_level = parent.upper_collider.translation.y - crouch_length
	
	crouch()
	
	
func exit_state():
	stand()
	parent.max_speed = current_max_speed
	

func process_unhandled_input(event):
	pass
	
func physics_process(delta):
	if Input.is_action_just_released("crouch"):
		parent.remove_state(self)
	
func crouch():
	tween.interpolate_property(upper_collider, "translation:y", upper_collider.translation.y, crouch_level, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func stand():
	tween.interpolate_property(upper_collider, "translation:y", upper_collider.translation.y, stand_level, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
