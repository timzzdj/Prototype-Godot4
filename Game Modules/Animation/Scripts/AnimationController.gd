extends Node # Class Type
class_name AnimationControl # Class Name
#****************************************************************************#
#								Object Properties							 #
#****************************************************************************#
@export var animationStatus : StateMapping	  # Animation Status IDs
@export var animationTree 	: AnimationTree	  # Character Animation Tree
@export var animationPlayer : AnimationPlayer # Character Animation Player
#****************************************************************************#
#								Fields									 	 #
#****************************************************************************#
var weaponID 			 : int	  # Active Weapon ID
var movementID 			 : int	  # Active Movement ID
var is_movement_reversed : bool	  # Movement momentum state
var animation_playing 	 : String # Active Animation Name
var anim_forward_speed 	 : float  # Animation forward momentum value
var anim_backward_speed  : float  # Animation backward momentum value
#****************************************************************************#
#								Functions								 	 #
#****************************************************************************#
# Initializes Animation Controller Node
func _ready():
	# Sets movement momentum forward
	is_movement_reversed = false
# Process every frame
func _physics_process(delta):
	# Updates active movement animation
	update_movement_animation()
# Gets the active weapon ID
func _get_weaponID(_weaponID : int):
	weaponID = _weaponID
# Gets the active movement ID
func _get_movementID(_movementID : int):
	movementID = _movementID
# Gets the active movement momentum
func _get_mv_momentum(_fwd_m : float, _bwd_m : float):
	anim_forward_speed = _fwd_m
	anim_backward_speed = _bwd_m
# Gets the active animation
func _on_animation_started(_anim_name : String):
	animation_playing = _anim_name
# Checks if movement input is reversed
func _is_movement_reversed(_is_mv_reverse : bool):
		is_movement_reversed = _is_mv_reverse
#****************************************************************************#
#								Methods									 	 #
#****************************************************************************#
# Updates movement animation using active weaponID, movementID, and momentum 
func update_movement_animation():
	# Checks if the player is running back and limit it to walk
	if is_movement_reversed and movementID == 3:
		movementID = 2
	# Checks if a weapon is active and update the animation accordingly
	if weaponID != 9:
		animationTree.set("parameters/Interaction_Transition/transition_request", "Combat_Actions")
		animationTree.set("parameters/Weapon_Transition/transition_request", str(weaponID) + "_Weapon")
		animationTree.set("parameters/" + str(weaponID) + "_Combo" + "/transition_request", "mv_ID" + str(weaponID))
	else:
		animationTree.set("parameters/Interaction_Transition/transition_request", "General_Actions")
		animationTree.set("parameters/GeneralActions_Transition/transition_request", "mv_ID" + str(weaponID))
	# Sets the active animation
	animationTree.set("parameters/mv_stateID" + str(weaponID) + "/transition_request", str(weaponID) + "_" + str(movementID))
	# Checks if the player is moving back and set the momentum accordingly
	if is_movement_reversed:
		animationTree.set("parameters/Delay_SpeedUp/scale", anim_backward_speed)
	else:
		animationTree.set("parameters/Delay_SpeedUp/scale", anim_forward_speed)
