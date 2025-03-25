class_name GrappleablePoint extends Area3D

@export var inactiveMat : StandardMaterial3D
@export var activeMat : StandardMaterial3D
@export var targettedMat : StandardMaterial3D

func _ready():
	print(get_parent().get_class())
	assert(get_parent() is GeometryInstance3D)

func setActive():
	get_parent().material_override = activeMat

func setInactive():
	get_parent().material_override = inactiveMat

func setTargetted():
	get_parent().material_override = targettedMat
