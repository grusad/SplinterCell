extends SpotLight

var entities = []

func _ready():
	var area = get_node("Area")
	area.connect("body_entered", self, "on_body_eneterd")
	area.connect("body_exited", self, "on_body_exited")
	

func _physics_process(delta):
	process_visiblility(delta)
	
func process_visiblility(delta):
	var max_distance_squared = pow(spot_range, 2)
	var light_position = global_transform.origin
	var max_angle = deg2rad(spot_angle)
	for entity in entities:
		var entity_pos = entity.global_transform.origin
		var distance = light_position.distance_squared_to(entity_pos)
		if distance > max_distance_squared:
			continue
			
		var light_facing = -global_transform.basis.z
		var light_to_entity = light_position.direction_to(entity_pos)
		var light_to_entity_normal = light_to_entity.normalized()
		var cos_angle = light_to_entity_normal.dot(light_facing)
		var angle = acos(cos_angle)
		
		if angle < max_angle:
			entity.stats.light_visibility = 1
		else:
			entity.stats.light_visibility = 0
		

func on_body_eneterd(body):
	entities.push_back(body)
	
func on_body_exited(body):
	entities.erase(body)
