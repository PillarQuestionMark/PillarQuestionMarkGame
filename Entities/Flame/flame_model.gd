extends MeshInstance3D


@export var color := Color("#e1a845"):
	set(value):
		color = value
		_update_color()

var _material: StandardMaterial3D = preload("res://Entities/Flame/material_flame.tres")

func _ready() -> void:
	# by default, all flames (and all parts of the model) share the same
	# material instance. we want each flame to have its own material so we can
	# change its color, but also share that material among all parts of that
	# flame's model.
	# i'm using the surface material override so we don't have to duplicate
	# the mesh resource too.
	_material = _material.duplicate()
	if (mesh != null):
		set_surface_override_material(0, _material)
	$MediumBall.set_surface_override_material(0, _material)
	$SmallBall.set_surface_override_material(0, _material)
	
	_update_color()

# this is really gonna depend on the model we use
func _update_color() -> void:
	_material.albedo_color = color
	_material.emission = color
