class_name AnimationStatus
extends Resource

#@export_category("Animation Status")
# Unique ID of active animation
@export var animation_uid : int = 0
# Group ID of active animation
@export var animation_guid : int = 0
# Animation state effects
@export var animation_state : String = "Normal"
# Animation active status
@export var is_active : bool = false

