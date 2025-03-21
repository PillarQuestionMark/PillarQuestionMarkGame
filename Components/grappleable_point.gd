class_name GrappleablePoint extends Area3D

@export var inactiveMat : StandardMaterial3D
@export var activeMat : StandardMaterial3D

func _ready():
	print(get_parent().get_class())
	assert(get_parent() is GeometryInstance3D)

var grappleActive : bool = false :
	set(value):
		grappleActive = value
		if grappleActive:
			get_parent().material_override = activeMat
		else:
			get_parent().material_override = inactiveMat

func toggle():
	grappleActive = not grappleActive
