extends Node # Class Type
class_name ActionControl # Class Name
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
signal set_equipped_weapon(_current_weapon : int)
#****************************************************************************#
#								Class Dictionary							 #
#****************************************************************************#
@export var lists_guid : StateMapping	# Movement State ID List
#****************************************************************************#
#								Fields										 #
#****************************************************************************#
var weapon_list 	   : Array = [] # Weapon dictionary Keys
var weapon_val 		   : Array = [] # Weapon dictionary Values
var previous_weapon	   : int		# Previous weapon Index
var current_weapon 	   : int	    # Current weapon Index
var current_weaponNode : Node3D		# Current weapon Node Path
var is_sheathed		   : bool		# Weapon sheathed status
var is_dashing		   : bool		# User active dashing status
var mv_state		   : int		# Current movement state
var dash_timer		   : float = 0  # Active Dash timer
var mv_dir			   : Vector3	# User Movement direction
const nw_ID			   : int = 9	# No Weapon ID
#****************************************************************************#
#								FUnctions									 #
#****************************************************************************#
# Initializes Action Controller Node
func _ready():
	# Set active weapon to No Weapon
	current_weapon = nw_ID
	# Sets sheathed status
	is_sheathed = true
	# Sets the initialze active dashing status
	is_dashing = false
	# Gets the weapon keys from GUID Lists
	weapon_list = lists_guid.weapon_guid.keys()
	# Gets the weapon node paths from GUID Lists
	weapon_val = lists_guid.weapon_guid.values()
	# Updates equipped weapon ID
	set_equipped_weapon.emit(current_weapon)
# Process User Input
func _input(event):
	# Checks if user sheathed
	if event.is_action_pressed("act_sheath"):
		sheath_weapon()
		update_weapon()
	# Checks if user is sheathed
	if !is_sheathed:
		# Checks if the user cycled the weapon wheel back
		if event.is_action_pressed("act_switch1"):
			cycle_weapon(-1)
		# Checks if the user cycled the weapon wheel forward
		elif event.is_action_pressed("act_switch2"):
			cycle_weapon(1)
# Process every frame
func _physics_process(delta):
	pass
#****************************************************************************#
#								Methods										 #
#****************************************************************************#
# Changes the current weapon index
func cycle_weapon(direction : int):
	# Changes the index based on user input
	current_weapon = (current_weapon + direction) % weapon_list.size()
	# Checks if index should be wrapped around max size of list
	if current_weapon < 0:
		current_weapon = weapon_list.size() - 1
	# Updates currently equipped weapon based on index
	update_weapon()
	# Updates animation based on equipped weapon
	set_equipped_weapon.emit(current_weapon)
# Updates currently equipped weapon
func update_weapon():
	# Loops processing each node in related groups and hide it
	for group_name in lists_guid.weapon_guid.values():
		var nodes = get_tree().get_nodes_in_group(group_name)
		for node in nodes:
			node.visible = false
	# Checks if there is a weapon selected to equip
	if current_weapon != nw_ID:
		# Gets the node of the selected weapon
		var current_weaponName = weapon_list[current_weapon]
		var current_group = lists_guid.weapon_guid[current_weaponName]
		var nodes = get_tree().get_nodes_in_group(current_group)
		for node in nodes:
			node.visible = true
	elif current_weapon == nw_ID:
		var nodes = get_tree().get_nodes_in_group(str(nw_ID)+"_NW")
		for node in nodes:
			node.visible = true
# Sheathes or Unsheathes weapon
func sheath_weapon():
	# Inverts sheathed status
	is_sheathed = !is_sheathed
	# Checks if a weapon is equipped to sheath or unsheath
	if current_weapon != nw_ID:
		previous_weapon = current_weapon
		current_weapon = nw_ID
	else:
		current_weapon = previous_weapon
	# Updates animation based on equipped weapon
	set_equipped_weapon.emit(current_weapon)
		
