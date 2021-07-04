extends Node
class_name State

var parent : KinematicEntity = null
var previous_state = null
var parameters = {}



func enter_state(parent, previous_state, parameters = {}):
	self.parent = parent
	self.previous_state = previous_state
	self.parameters = parameters

	
func exit_state():
	pass

func physics_process(delta):
	pass

func transition_to(new_state, parameters = {}):
	parent.remove_state(self)
	new_state.enter_state(parent, self, parameters)
	parent.push_state(new_state)

func post_add_event():
	pass

func post_remove_event():
	pass
