extends RayCast

var target : HitData = null

func _physics_process(delta):
	if is_colliding():
		target = HitData.new(get_collider(), get_collision_point(), get_collision_normal())
	else:
		target = null

		
class HitData:
	var hit_object = null
	var hit_position = null
	var hit_normal = null
	
	func _init(object, position, normal):
		self.hit_object = object
		self.hit_position = position
		self.hit_normal = normal

