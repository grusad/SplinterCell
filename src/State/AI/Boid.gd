extends Node
class_name Boid


var detectors = []
var sensors = []
var perception_radius = 50
var steer_force = 50.0
var alignment_force = 0.6
var cohesion_force = 0.6
var seperation_force = 1.0
var avoidance_force = 3.0

var parent = null

func _init(parent):
	self.parent = parent
	for i in range(-1, 2):
		var ray = RayCast.new()
		ray.enabled = true
		parent.add_child(ray)
		ray.cast_to = Vector3.BACK * 2
		ray.translation = Vector3(i * 0.25, 0.5, 0)
		ray.collision_mask = 4
		detectors.push_back(ray)
		
	var angle = PI
	var angle_interval = 2 * PI / 8

	for i in 8:
		var ray = RayCast.new()
		ray.enabled = true
		parent.add_child(ray)
		ray.cast_to = Vector3.BACK * 2
		ray.translation = Vector3(0, 0.5, 0)
		ray.collision_mask = 4
		
		
		Vector2(0, -1).rotated(angle)
		ray.rotate_y(angle)
		angle += angle_interval
		
		sensors.push_back(ray)
		

func _process(delta):
	
	return
	var neighbors = get_neighbors()
	
	#acceleration += process_alignments(neighbors) * alignment_force
	#acceleration += process_cohesion(neighbors) * cohesion_force
	#acceleration += process_seperation(neighbors) * seperation_force

	#if is_obsticle_ahead():
		#acceleration += process_obsticle_avoidance() * avoidance_force
		
	#velocity += acceleration * delta
	#velocity = velocity.clamped(move_speed)
	#parent.rotation = velocity.angle()

func process_cohesion(neighbors):
	var vector = Vector2()
	if neighbors.empty():
		return vector
	for boid in neighbors:
		vector += boid.position
	vector /= neighbors.size()
	return steer((parent.vector - parent.global_transform.origin).normalized() * parent.move_speed)
		

func process_alignments(neighbors):
	var vector = Vector3()
	if neighbors.empty():
		return vector
		
	for boid in neighbors:
		vector += boid.velocity
	vector /= neighbors.size()
	return steer(vector.normalized() * parent.move_speed)

func process_seperation(velocity):
	var vector = Vector3()
	var close_neighbors = []
	for boid in get_neighbors():
		if parent.global_transform.origin.distance_to(boid.global_transform.origin) < perception_radius / 2:
			close_neighbors.push_back(boid)
	if close_neighbors.empty():
		return vector
	
	for boid in close_neighbors:
		var difference = parent.global_transform.origin - boid.global_transform.origin
		if difference.length() != 0:
			vector += difference.normalized() / difference.length()
	
	vector /= close_neighbors.size()
	return steer(vector.normalized() * parent.max_speed)
	

func steer(var target):
	var steer = target - parent.velocity
	steer = steer.normalized() * steer_force
	return steer
	
func is_obsticle_ahead():
	for ray in detectors:
		if ray.is_colliding():
			return true
	return false

func process_obsticle_avoidance():
	for ray in sensors:
		if not ray.is_colliding():
			return steer((ray.cast_to.rotated(ray.rotation + parent.rotation)).normalized())
			
	return Vector3.ZERO

func get_neighbors():
	var neighbors = get_tree().get_nodes_in_group("Enemy")
	for boid in neighbors:
		if boid == parent:
			neighbors.erase(parent)
			
	return neighbors
	
func velocity():
	return parent.velocity()
