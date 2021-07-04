extends State

var weapon_texture : PlayerWeaponTexture = null
var timer = null
var can_fire = false

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.connect("timeout", self, "on_timer_timeout")

func enter_state(parent, previous_state = null, parameters = {}):
	.enter_state(parent, previous_state, parameters)
	weapon_texture = parent.get_weapon_texture()
	weapon_texture.set_item(PlayerWeaponTexture.Item.PISTOL, PlayerWeaponTexture.Mode.AIM)
	parent.play_animation("aim_animation")
	
	can_fire = true
	
	
func exit_state():
	weapon_texture.set_item(PlayerWeaponTexture.Item.PISTOL, PlayerWeaponTexture.Mode.REST)


func process_unhandled_input(event):
	pass
	
func physics_process(delta):
	if Input.is_action_just_released("aim"):
		parent.remove_state(self)
	
	if Input.is_action_just_pressed("fire") and can_fire:
		fire()
	
func post_remove_event():
	parent.play_animation("idle_animation")
	
func fire():
	weapon_texture.rect_rotation = 2
	can_fire = false
	timer.start()
	
func on_timer_timeout():
	can_fire = true
	weapon_texture.rect_rotation = 0
