extends Node # Class Type
class_name ActionControl # Class Name
#****************************************************************************#
#								Signals									 	 #
#****************************************************************************#
signal set_equipped_weapon(_current_weapon : int)
#****************************************************************************#
#								Class Dictionary							 #
#****************************************************************************#
@export var lists_guid : StateMapping
#****************************************************************************#
#								Fields										 #
#****************************************************************************#
var weapon_list 	   : Array = [] # Weapon dictionary Keys
var weapon_val 		   : Array = [] # Weapon dictionary Values
var current_weapon 	   : int   = 0  # Current weapon Index
var current_weaponNode : Node3D		# Current weapon Node Path
#****************************************************************************#
#								FUnctions									 #
#****************************************************************************#
# Initializes Action Controller Node
func _ready():
	# Gets the weapon keys from GUID Lists
	weapon_list = lists_guid.weapon_guid.keys()
	# Gets the weapon node paths from GUID Lists
	weapon_val = lists_guid.weapon_guid.values()
	pass
# Process User Input
func _input(event):
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
	set_equipped_weapon.emit(current_weapon)
# Updates currently equipped weapon
func update_weapon():
	# Loops processign each node in related groups
	for group_name in lists_guid.weapon_guid.values():
		var nodes = get_tree().get_nodes_in_group(group_name)
		for node in nodes:
			node.visible = false
	# Gets the node of the selected weapon
	var current_weaponName = weapon_list[current_weapon]
	# Checks if there is a weapon selected to equip
	if current_weaponName != "0NW":
		var current_group = lists_guid.weapon_guid[current_weaponName]
		var nodes = get_tree().get_nodes_in_group(current_group)
		for node in nodes:
			node.visible = true
