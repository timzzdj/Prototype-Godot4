extends Resource
class_name StateMapping

@export var movement_state_map := {
	"0_1": preload("res://Game Modules/Classes/MovementClasses/DW_IdleStance.tres"),
	"0_3": preload("res://Game Modules/Classes/MovementClasses/DW_RunStance.tres"),
	"0_2": preload("res://Game Modules/Classes/MovementClasses/DW_WalkStance.tres"),
	"1_1": preload("res://Game Modules/Classes/MovementClasses/GS_IdleStance.tres"),
	"1_2": preload("res://Game Modules/Classes/MovementClasses/GS_WalkStance.tres"),
	"1_3": preload("res://Game Modules/Classes/MovementClasses/GS_RunStance.tres"),
	"2_1": preload("res://Game Modules/Classes/MovementClasses/SAS_IdleStance.tres"),
	"2_2": preload("res://Game Modules/Classes/MovementClasses/SAS_WalkStance.tres"),
	"2_3": preload("res://Game Modules/Classes/MovementClasses/SAS_RunStance.tres"),
	"9_1": preload("res://Game Modules/Classes/MovementClasses/General_IdleStance.tres"),
	"9_2": preload("res://Game Modules/Classes/MovementClasses/General_WalkStance.tres"),
	"9_3": preload("res://Game Modules/Classes/MovementClasses/General_RunStance.tres")
}

@export var animation_guid := {
	
}

@export var action_guid := {
	
}

@export var weapon_guid := {
	"0DW": "0_DW",
	"1GS": "1_TH",
	"2SAS": "2_SAS"
}
