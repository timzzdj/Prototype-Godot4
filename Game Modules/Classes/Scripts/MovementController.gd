class_name MovementState # Class Name
extends Node # Class Type
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
signal set_movementAnimID(_mv_ID : int)
#****************************************************************************#
#								Class Dictionary							 #
#****************************************************************************#
@export_category("MovementStates")
@export var mv_stateLists : StateMapping # Movement resource list
#****************************************************************************#
#								Object Properties							 #
#****************************************************************************#
@export_category("Player Nodes")
@export var player 		   : CharacterBody3D # Player Node
@export var player_mesh    : Node3D			 # Player Mesh Node
#****************************************************************************#
#								Constants									 #
#****************************************************************************#
const def_speed 		: float = 5.0 # Default Player Speed
const def_rotationSpeed : float = 1.0 # Default Player Rotation Speed
const def_weight 		: float = 1.0 # Default Player Weight
#****************************************************************************#
#								Fields										 #
#****************************************************************************#
var camera_rotation   : float = 0	# Camera look at direction
var speed 			  : float = 5.0 # Player Movement Speed
var weight 			  : float = 1	# Player Movement Weight
var rotation_speed	  : float = 1	# Player Turn Speed
var direction 		  : Vector3		# Player turn node direction
var input_direction   : Vector3		# User input direction
var lateral_direction : Vector3		# Side movement direction
var medial_direction  : Vector3		# Front and back movement direction
var velocity 		  : Vector3		# Player movement velocity
var equipped_weapon	  : int			# Equipped Weapon ID
var movementState	  : int			# Current Movement State ID
#****************************************************************************#
#								Functions								 	 #
#****************************************************************************#
# Initializes Movement Controller Node
func _ready():
	# Sets the initial movement state to idle
	movementState = 1
	# Updates movement stat based on current movement state
	update_movementStats(movementState)
# Process one shot input events
func _input(event):
	pass
# Process every frame
func _physics_process(delta):
	# Update movement state
	update_movement()
	# Update movement attribute status
	update_movementStats(movementState)
	# Checks if there is movement input
	if direction:
		# Gets the 2D angle of the movement direction in XZ plane
		var target_angle = atan2(direction.x, direction.z)
		# Checks if player is moving back to adjust angle and reduce speed
		if input_direction.z != 0 and input_direction.z < 0:
			target_angle += PI
			speed = def_speed - def_weight
		# Sets velocity based on current speed and directional input
		velocity.x = speed * direction.normalized().x
		velocity.z = speed * direction.normalized().z
		# Sets smooth rotation of player mesh towards the target angle
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, target_angle, rotation_speed * delta)
	else:
		# Sets the velocity to gradually come to a stop
		velocity.x = move_toward(velocity.x, 0, def_weight)
		velocity.z = move_toward(velocity.z, 0, def_weight)
	# Applies the calculated velocity and handles player movement
	player.velocity = velocity
	player.move_and_slide()
# Sets movement direction from user input
func _set_movement_direction(_movement_direction : Vector3):
	lateral_direction = Vector3(cos(camera_rotation), 0, -sin(camera_rotation)).normalized()
	medial_direction = Vector3(sin(camera_rotation), 0, cos(camera_rotation)).normalized()
	input_direction = _movement_direction
	direction = (lateral_direction * -input_direction.x + 
				 medial_direction * -input_direction.z
				 ).normalized()
# Gets current camera rotation angle
func _update_camera_rotation(_camera_rotation : float):
	camera_rotation = _camera_rotation
# Gets the equipped weapon ID
func _get_equipped_weapon(_current_weapon):
	equipped_weapon = _current_weapon
#****************************************************************************#
#								Methods									 	 #
#****************************************************************************#
# Updates the player's current movement state
func update_movement():
	# Checks if input is to Run, Idle, or Walk
	if Input.is_action_pressed("mv_basic"):
		movementState = 2
		if Input.is_action_pressed("mv_run"):
			movementState = 3
	elif input_direction == Vector3.ZERO:
		movementState = 1
	set_movementAnimID.emit(movementState)
# Updates the player's current stats for movement
func update_movementStats(mv_state : int):
	# Gets movement map key using weapon ID and movement ID
	var combined_key = str(equipped_weapon) + "_" + str(mv_state)
	# Gets resource item using combined key
	var r_matching_state : MovementStances = mv_stateLists.movement_state_map.get(combined_key, null)
	# Checks if current movement state and equipped weapon matches with resource item attributes
	if r_matching_state.movement_stateID == mv_state and r_matching_state.active_weaponID == equipped_weapon:
		# Gets new movement speed from current resource item attribute
		speed = r_matching_state.movement_speed * def_speed
		# Gets new rotation speed from current resource item attribute
		rotation_speed = r_matching_state.movement_weight + def_speed
