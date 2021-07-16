extends GridContainer

var player = null

func _process(delta):
	$Visibility.text = str(player.stats.light_visibility)
