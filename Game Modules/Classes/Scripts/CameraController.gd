extends Node3D
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
# Updates associated nodes of the current camera rotation
signal update_camera_rotation(_camera_rotation : float)
#****************************************************************************#
#								Node Paths									 #
#****************************************************************************#
@export var horizontal_camNode : Node3D
@export var vertical_camNode : Node3D
@export var camera : Camera3D
#****************************************************************************#
#								Object Properties							 #
#****************************************************************************#
@export var zoom_speed : float = 1.0  # Camera FOV zoom speed
@export var min_fov    : float = 30.0 # Minimum field of vision distance
@export var max_fov    : float = 75.0 # Maximum field of vision distance
#****************************************************************************#
#								Fields									 	 #
#****************************************************************************#
var yaw 			   : float = 0	  # Horizontal rotation value
var pitch 			   : float = 0	  # Vertical rotation value
var yaw_sensitivity    : float = 0.02 # Horizontal rotation sensitivity
var pitch_sensitivity  : float = 0.02 # Vertical rotation sensitivity
var yaw_acceleration   : float = 10	  # Horizontal rotation speed
var pitch_acceleration : float = 10	  # Vertical rotation speed
var pitch_max 		   : float = 50	  # Vertical rotation lower limit
var pitch_min 		   : float = -55  # Vertical rotation upper limit
var is_mouse_hidden    : bool		  # Mouse visibility state
#****************************************************************************#
#								Functions								 	 #
#****************************************************************************#
# Initialize Camera Root Node
func _ready():
	# Lock mouse to active window and hides it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Update mouse visibility state
	is_mouse_hidden = true
# Process User Input
func _input(event):
	# Checks if 'Esc' is pressed and update mouse visibility state
	if Input.is_action_just_pressed("ui_cancel"):
		is_mouse_hidden = hide_mouse(is_mouse_hidden)
	# Checks if mouse is visible
	if is_mouse_hidden:
		# Checks if Mouse Wheel input is triggered and zoom camera accordingly
		if event is InputEventMouseButton:
			zoom_camera(event)
		# Checks if Mouse Pointer has moved and rotate camera accordingly
		elif event is InputEventMouseMotion:
			yaw   += -event.relative.x * yaw_sensitivity
			pitch += -event.relative.y * pitch_sensitivity
# Process every frame
func _physics_process(delta):
	# Limit vertical camera rotation
	pitch = clamp(pitch, pitch_min, pitch_max)
	# Rotate camera horizontally
	horizontal_camNode.rotation_degrees.y = lerp(horizontal_camNode.rotation_degrees.y,
												 yaw,
												 yaw_acceleration * delta)
	# Rotate camera vertically
	vertical_camNode.rotation_degrees.x = lerp(vertical_camNode.rotation_degrees.x,
											   pitch,
											   pitch_acceleration * delta)
	# Update associated nodes with the latest camera's horizontal rotation
	update_camera_rotation.emit(horizontal_camNode.rotation.y)
#****************************************************************************#
#								Methods									 	 #
#****************************************************************************#
# Zooms Camera based on Field of Vision Values
func zoom_camera(_event : InputEventMouseButton):
	if _event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if camera.fov > min_fov:
			camera.fov -= zoom_speed
		else:
			camera.fov = min_fov
	elif _event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if camera.fov < max_fov:
			camera.fov += zoom_speed
		else:
			camera.fov = max_fov
# Sets the mouse to hidden or visible based on its current state
func hide_mouse(_is_mouse_hidden : bool) -> bool:
	if _is_mouse_hidden:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_is_mouse_hidden = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_is_mouse_hidden = true
	return _is_mouse_hidden
