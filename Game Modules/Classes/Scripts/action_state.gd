extends Resource
class_name ActionState

# Active action of player
@export var action_guid : int = 0
# Active weapon of player
@export var weapon_uid : int = 9
# Status of current action
@export var is_actionActive : bool = false
# Status of interactable state
@export var is_sheathed : bool = false

