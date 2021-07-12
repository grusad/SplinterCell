extends Node
class_name State

var parent : KinematicEntity = null
var previous_state = null
var parameters = {}
var children = []

func enter_state(parent, previous_state, parameters = {}):
	self.parent = parent
	self.previous_state = previous_state
	self.parameters = parameters
	
func exit_state():
	for child in children:
		child.exit_state()

func physics_process(delta):
	for child in children:
		child.physics_process(delta)

func transition_to(new_state, parameters = {}):
	parent.remove_state(self)
	parent.push_state(new_state, self, parameters)

func post_add_event():
	for child in children:
		child.post_add_event()

func post_remove_event():
	for child in children:
		child.post_remove_event()
		
func add_child_state(state, parameters = {}):
	state.enter_state(parent, null, parameters)

func remove_child_state(state):
	state.exit_state()
	children.erase(state)
