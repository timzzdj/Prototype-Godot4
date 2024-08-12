extends Node
class_name AnimationControl

@export_category("Animation Status")
@export var animationStatus : StateMapping

@export var animationTree : AnimationTree
@export var animationPlayer : AnimationPlayer

var weaponID : int
var movementID : int

func _ready():
	pass

func _physics_process(delta):
	update_movement_animation()

func _get_weaponID(_weaponID : int):
	weaponID = _weaponID

func _get_movementID(_movementID : int):
	movementID = _movementID
	pass

func update_movement_animation():
	if weaponID:
		animationTree.set("parameters/Interaction_Transition/transition_request", "Combat_Actions")
		animationTree.set("parameters/Weapon_Transition/transition_request", str(weaponID) + "_Weapon")
		animationTree.set("parameters/" + str(weaponID) + "_Combo" + "/transition_request", "mv_ID" + str(weaponID))
		animationTree.set("parameters/mv_stateID" + str(weaponID) + "/transition_request", str(weaponID) + "_" + str(movementID))
	else:
		animationTree.set("parameters/Interaction_Transition/transition_request", "General_Actions")
		animationTree.set("parameters/GeneralActions_Transition/transition_request", "mv_ID" + str(weaponID))
		animationTree.set("parameters/mv_stateID" + str(weaponID) + "/transition_request", str(weaponID) + "_" + str(movementID))
