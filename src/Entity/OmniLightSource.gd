extends OmniLight

var entities = []
var ray_map = {}

func _ready():
	var area = get_node("Area")
	var collision_shape =  get_node("Area/CollisionShape")
	
	collision_shape.shape.radius = omni_range
	area.connect("body_entered", self, "on_body_entered")
	area.connect("body_exited", self, "on_body_exited")
	
func _physics_process(delta):
	for key in ray_map.keys():
		var ray_cast = ray_map.get(key)
		
		var direction_to_target = global_transform.origin.direction_to(key.global_transform.origin)
		ray_cast.cast_to = direction_to_target * omni_range
		ray_cast.rotation_degrees = -get_parent().rotation_degrees
		var visibility = 0
		if ray_cast.is_colliding():
			var object = ray_cast.get_collider()
			if object.is_in_group("KinematicEntity"):
				var distance = global_transform.origin.distance_to(object.global_transform.origin)
				visibility = clamp(1 - (distance / omni_range), 0, 1)
				object.light_visible = visibility
				
		else:
			key.light_visible = 0
			
	
		
		
	
		
func on_body_entered(body):
	entities.push_back(body)
	var ray = RayCast.new()
	ray.enabled = true
	ray.set_collision_mask_bit(1, true)
	ray.set_collision_mask_bit(2, true)
	ray.set_collision_mask_bit(3, true)
	add_child(ray)
	ray_map[body] = ray
	
func on_body_exited(body):
	entities.erase(body)
	var ray = ray_map.get(body)
	ray_map.erase(body)
	ray.queue_free()
