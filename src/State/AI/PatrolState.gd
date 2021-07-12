extends State



func enter_state(parent, previous_state, parameters = {}):
	.enter_state(parent, previous_state, parameters)	
	parent.get_vision().connect("player_alert", self, "on_player_alert")
	parent.play_animation("idle_animation")
	
	
	
func exit_state():
	parent.get_vision().disconnect("player_alert", self, "on_player_alert")

func physics_process(delta):
	parent.apply_friction(3, delta)

func on_player_alert(player):
	transition_to(parent.get_state("CombatState"), {"target": player, "update_path_time": 1})
	
