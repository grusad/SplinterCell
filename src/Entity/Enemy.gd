extends KinematicEntity

onready var sprite = $Sprite3D
onready var player = get_tree().root.get_node("/root/Test/Player")
onready var navigation = get_tree().root.get_node("root/Test/Navigation")
	

func _physics_process(delta):
	._physics_process(delta)
	process_modulate()
	
	
func process_modulate():
	var a = self.global_transform.basis.z
	var b = (player.global_transform.origin - self.global_transform.origin).normalized()
	
	if acos(a.dot(b)) <= deg2rad(90):
		sprite.modulate = Color.white
	else:
		sprite.modulate = Color.black
