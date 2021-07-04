extends TextureRect
class_name PlayerWeaponTexture

enum Item {
	PISTOL,
	SNIPER
}

enum Mode {
	REST,
	AIM
}


func set_item(item, mode):
	var atlas_position = Vector2()
	match item:
		Item.PISTOL:
			atlas_position = Vector2(0, 0)
		Item.PISTOL:
			atlas_position = Vector2(1, 0)

	if mode == Mode.AIM:
		atlas_position.x += 1
	
	texture.region = Rect2(atlas_position * 32, Vector2.ONE * 32)
