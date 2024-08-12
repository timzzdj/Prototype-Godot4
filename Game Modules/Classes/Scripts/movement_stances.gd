class_name MovementStances
extends Resource

@export_category("Movement Stances")
# ID of current idle state
@export var movement_stateID : int   = 0   
# ID of current active weapon
@export var active_weaponID  : int   = 0   
# Affects the next walk/run movement 
@export var movement_speed   : float = 0.0 
# Reduce speed with this value (based on active weapon)
@export var movement_weight  : float = 1.0 
