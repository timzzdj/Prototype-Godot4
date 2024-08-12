extends Resource
class_name StateMapping

@export var movement_state_map := {
	"1_1": preload("res://Game Modules/Classes/MovementClasses/DW_IdleStance.tres"),
	"1_3": preload("res://Game Modules/Classes/MovementClasses/DW_RunStance.tres"),
	"1_2": preload("res://Game Modules/Classes/MovementClasses/DW_WalkStance.tres"),
	"2_1": preload("res://Game Modules/Classes/MovementClasses/GS_IdleStance.tres"),
	"2_2": preload("res://Game Modules/Classes/MovementClasses/GS_WalkStance.tres"),
	"2_3": preload("res://Game Modules/Classes/MovementClasses/GS_RunStance.tres"),
	"3_1": preload("res://Game Modules/Classes/MovementClasses/SAS_IdleStance.tres"),
	"3_2": preload("res://Game Modules/Classes/MovementClasses/SAS_WalkStance.tres"),
	"3_3": preload("res://Game Modules/Classes/MovementClasses/SAS_RunStance.tres"),
	"0_1": preload("res://Game Modules/Classes/MovementClasses/General_IdleStance.tres"),
	"0_2": preload("res://Game Modules/Classes/MovementClasses/General_WalkStance.tres"),
	"0_3": preload("res://Game Modules/Classes/MovementClasses/General_RunStance.tres")
}

@export var animation_guid := {
	
}

@export var action_guid := {
	
}

@export var weapon_guid := {
	"0NW" : "0_NW",
	"1DW": "1_DW",
	"2GS": "2_TH",
	"3SAS": "3_SAS"
}
