class_name MovementState # Class Name
extends Node # Class Type
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
signal set_movementAnimID(_mv_ID : int)
signal is_movementReversed(_is_reversed : bool)
signal get_mv_momentum(_fwd_m : float, _bwd_m : float)
#****************************************************************************#
#								Classes Objects								 #
#****************************************************************************#
@export_category("Movement State List")
@export var mv_stateLists : StateMapping # Movement resource list
@export_category("Dash Attributes")
@export var passive_dash : DashModule # Passive Dash resource attributes
@export var active_dash  : DashModule # Active Dash resource attribtues
#****************************************************************************#
#								Node Objects								 #
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
var psv_dash_timer	  : float = 0	# Player Passive dash timer
var act_dash_timer	  : float = 0	# Player Active dash timer
var dash_duration 	  : float = 0	# Player passive dash duration
var local_timer	 	  : float = 0	# Global delta time
var direction 		  : Vector3		# Player turn node direction
var input_direction   : Vector3		# User input direction
var lateral_direction : Vector3		# Side movement direction
var medial_direction  : Vector3		# Front and back movement direction
var velocity 		  : Vector3		# Player movement velocity
var equipped_weapon	  : int			# Equipped Weapon ID
var movementState	  : int			# Current Movement State ID
var is_dashing		  : bool		# Player dashing status
#****************************************************************************#
#								Functions								 	 #
#****************************************************************************#
# Initializes Movement Controller Node
func _ready():
	# Sets the initial movement state to idle
	movementState = 1
	# Updates movement stat based on current movement state
	update_movementStats(movementState)
	# Sets the initial dash status
	is_dashing = false
# Process one shot input events
func _input(event):
	pass
# Process every frame
func _physics_process(delta):
	local_timer = delta
	# Update active and passive dash movements
	update_dash_movements()
	# Update movement state
	update_movement_state()
	# Update movement attribute status
	update_movementStats(movementState)
	# Process and update player movements
	update_player_movement()
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
func update_movement_state():
	# Checks if input is to Run, Idle, or Walk
	if Input.is_action_pressed("mv_basic"):
		movementState = 2
		if Input.is_action_pressed("mv_run") and not is_dashing:
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
	# Updates Animation speed based on current movement state momentum
	get_mv_momentum.emit(r_matching_state.fwd_momentum, r_matching_state.bwd_momentum)
# Updates movement status and state for moving backwards
func is_movingBack(target_angle : float) -> float:
	# Sets the current movement animation to normal
	is_movementReversed.emit(false)
	# Checks if player is moving back to adjust angle and reduce speed
	if input_direction.z != 0 and input_direction.z < 0:
		target_angle += PI
		speed = def_speed - def_weight
		# Updates animation for reverse movement
		is_movementReversed.emit(true)
	elif input_direction.z < 0:
		# Updates animation for reverse movement
		is_movementReversed.emit(true)
	return target_angle
# Process and update player movements
func update_player_movement():
	# Checks if there is movement input
	if direction != Vector3.ZERO:
		# Gets the 2D angle of the movement direction in XZ plane
		var target_angle = atan2(direction.x, direction.z)
		target_angle = is_movingBack(target_angle)
		if is_dashing:
			# Apply Dash velocity
			velocity.x = passive_dash.dash_speed * direction.normalized().x
			velocity.z = passive_dash.dash_speed * direction.normalized().z
		else:
			# Apply normal velocity based on current speed and directional input
			velocity.x = speed * direction.normalized().x
			velocity.z = speed * direction.normalized().z
		# Sets smooth rotation of player mesh towards the target angle
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, target_angle, rotation_speed * local_timer)
	else:
		# Sets the velocity to gradually come to a stop
		velocity.x = move_toward(velocity.x, 0, def_weight)
		velocity.z = move_toward(velocity.z, 0, def_weight)
	# Applies the calculated velocity and handles player movement
	player.velocity = velocity
	player.move_and_slide()
# Process player dashing status
func update_dash_movements():
	# Updates passive dash movements
	update_passive_dash()
	# Updates active dash movements
	update_active_dash()
	# Checks if the player is currently dashing
	if is_dashing:
		# Count down the dash duration
		dash_duration -= local_timer
		# Checks if the dashing is over
		if dash_duration <= 0:
			is_dashing = false
# Process Passive dash movements
func update_passive_dash():
	# Sets the class object for passive dash movements
	var passive_dash_attr = passive_dash
	# Checks if dash cooldown is running and update it
	if psv_dash_timer > 0:
		psv_dash_timer -= local_timer
	# Checks if the player is running and the dash cooldown is over
	if movementState == 3 and direction != Vector3.ZERO and psv_dash_timer <= 0:
		# Process passive dashing
		start_dash(passive_dash_attr)
# Process Active dash movements
func update_active_dash():
	# Sets the class object for active dash movements
	var active_dash_attr = active_dash
	# Checks if dash cooldown is running and update it
	if act_dash_timer > 0:
		act_dash_timer -= local_timer
	# Checks if the player input dash
	if Input.is_action_just_pressed("mv_dash"):
		# Checks if the player is not idle and the dash cooldown is over
		if ((movementState != 1) 		and 
			(direction != Vector3.ZERO) and 
			(act_dash_timer <= 0)):
			# Process active dashing
			start_dash(active_dash_attr)
# Handles passive and active dash attribute initialization
func start_dash(dash_attr : DashModule):
	is_dashing = true
	# Checks if the current dash action is passive or active
	if dash_attr.action_ID == 24:
		psv_dash_timer = dash_attr.dash_cooldown
		velocity = direction.normalized() * dash_attr.dash_speed
	elif dash_attr.action_ID == 25:
		var dash_dir = direction * dash_attr.dash_distance
		velocity.x = dash_dir.x * dash_attr.dash_speed
		velocity.z = dash_dir.z * dash_attr.dash_speed
		act_dash_timer = dash_attr.dash_cooldown
	dash_duration = dash_attr.dash_duration
