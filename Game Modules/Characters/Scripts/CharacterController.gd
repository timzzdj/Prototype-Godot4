extends CharacterBody3D
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
# Updates associated nodes of current input direction
signal update_general_movement(_movement_direction : Vector3)
# Updates associated nodes of current input actions
signal update_general_action()
#****************************************************************************#
#								Fields									 	 #
#****************************************************************************#
var input_direction : Vector3 # Basic movement direction
#****************************************************************************#
#								Functions								 	 #
#****************************************************************************#
# Initialize Player Node
func _input(event):
	# Checks for Input keys from the 'Basic Movement' group
	if event.is_action_pressed("mv_basic") or event.is_action_released("mv_basic"):
		# Gets the lateral movement key input
		input_direction.x = Input.get_action_strength("mv_left") - Input.get_action_strength("mv_right")
		# Gets the medial movement key input
		input_direction.z = Input.get_action_strength("mv_forward") - Input.get_action_strength("mv_back")
# Process every frame
func _physics_process(delta):
	# Updates associated node of the current input values
	update_general_movement.emit(input_direction)
