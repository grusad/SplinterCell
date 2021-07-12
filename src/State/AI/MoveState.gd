extends State

onready var navigation = get_tree().root.get_node("Test/Navigation")

var position = Vector3()
var path = Array()
var object = null
var timer = null
var update_path_time = null
var debug_path_nodes = []

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_timer_timeout")

func enter_state(parent, previous_state, parameters = {}):
	.enter_state(parent, previous_state, parameters)	
	
	var object = parameters.get("object")
	var position = parameters.get("position")
	var update_path_time = parameters.get("update_path_time")
	
	if object:
		self.object = object
		self.position = object.global_transform.origin
	
	if position:
		self.position = position
		
	if update_path_time:
		self.update_path_time = update_path_time
		timer.wait_time = update_path_time
		timer.start()
		
	find_path()
	

func exit_state():
	timer.stop()

func physics_process(delta):
	
	if update_path_time:
		position = object.global_transform.origin
	
	if not path.empty():
		if parent.global_transform.origin.distance_to(path[0]) < 0.5:
			path.remove(0)
	
	if not path.empty():
		parent.look_at(path[0], Vector3.UP)
		parent.rotation_degrees.y += 180
		parent.rotation_degrees.x = 0
		parent.rotation_degrees.z = 0
		var direction = (path[0] - parent.global_transform.origin).normalized()

		parent.apply_movement(direction, parent.acceleration, parent.max_speed, delta)

func find_path():
	path = navigation.get_simple_path(parent.global_transform.origin, position, true)
	
	if Globals.DEBUG_MODE:
		generate_debug()


func on_timer_timeout():
	find_path()

func generate_debug():
	for i in path:
		var mesh_instance = MeshInstance.new()
		mesh_instance.mesh = SphereMesh.new()
		get_tree().root.add_child(mesh_instance)
		mesh_instance.scale *= 0.1
		mesh_instance.global_transform.origin = i
