extends Area

const MAX_RAY_DISTANCE = 6

onready var player = get_tree().root.get_node("/root/Test/Player")
onready var ray_cast = get_node("RayCast")
onready var alert_sprite = get_node("AlertSprite")

signal player_alert 

var player_in_front = false
var player_in_sight = false
var player_in_fire_range = false
var player_in_ray = false
var player_in_area = false
var alert_timer = 0
var fire_range = 5


func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func _physics_process(delta):
	
	
	process_fov()
	process_ray_cast()
	process_alert_time(delta)
	
		
	var distance = global_transform.origin.distance_to(player.global_transform.origin)
	player_in_fire_range = true if (distance <= fire_range) else false

func see_player():
	return player_in_sight and player_in_ray
	
func can_fire():
	return see_player() and player_in_fire_range

func on_body_entered(body):
	player_in_area = true

func on_body_exited(body):
	player_in_area = false

func process_alert_time(delta):
	if see_player():
		var distance = global_transform.origin.distance_to(player.global_transform.origin)
		var light_factor = player.stats.light_visibility
		var distance_factor = 1 - (distance / MAX_RAY_DISTANCE)
		
		if light_factor <= 0:
			if distance > 2:
				distance_factor = 0
		
		var alert_factor = distance_factor + light_factor * delta	
		alert_timer += alert_factor
		if alert_timer >= 1.0:
			emit_signal("player_alert", player)
	else:
		alert_timer -= delta	
	
	alert_timer = clamp(alert_timer, 0.01, 1.0)
	var alpha = alert_timer / 1.0
	alpha = clamp(alpha, 0.1, 1)	
	alert_sprite.modulate.a = alpha
	
	
	
func process_ray_cast():
	var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	ray_cast.cast_to = direction_to_player * MAX_RAY_DISTANCE
	ray_cast.rotation_degrees = -get_parent().rotation_degrees
	
	if ray_cast.is_colliding():
		var object = ray_cast.get_collider()
		if object.is_in_group("Player"):
			player_in_ray = true
		else:
			player_in_ray = false
	else:
		player_in_ray = false
		
func process_fov():
	var a = self.global_transform.basis.z
	var b = (player.global_transform.origin - self.global_transform.origin).normalized()
	
	if acos(a.dot(b)) <= deg2rad(90):
		player_in_front = true
		player_in_sight = true
	else:
		player_in_front = false
		player_in_sight = false
