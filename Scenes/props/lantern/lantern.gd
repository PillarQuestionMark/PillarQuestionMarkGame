## lanterns!
##
## the light is static and is only visible via a baked lightmap.
## the light is disabled if the lantern is off.
##
## on _ready(), they duplicate their material so they can set its color
## without affecting other lanterns.
@tool
extends MeshInstance3D

@export var on := false:
	set(value):
		on = value
		if _is_ready:
			_duplicate_if_needed()
			_update_on()

@export var color := Color("c33c40"):
	set(value):
		color = value
		if _is_ready: # _update_color() will fail if _ready() isn't done yet
			_duplicate_if_needed()
			_update_color()

@export_group("Internal")
@export var surface_material_override_idx := 0 ## index of surface material override to use as the colored lantern material

@onready var light: OmniLight3D = $OmniLight3D
@onready var material: StandardMaterial3D = preload("res://Scenes/props/lantern/lantern_material.tres")

var _is_ready := false

func _ready() -> void:
	_duplicate_if_needed()
	
	_is_ready = true
	_update_on()
	_update_color()

func _duplicate_if_needed() -> void:
	# only duplicate if absolutely necessary, otherwise resource ids will change way too much and make git merges a pain
	if material.albedo_color == color and material.emission == color:
		return
	
	material = material.duplicate()
	set_surface_override_material(surface_material_override_idx, material)

func _update_color() -> void:
	material.albedo_color = color
	#material.albedo_color.a = 0.9 # transparency looks kinda ugly rn
	material.emission = color
	light.light_color = color

func _update_on() -> void:
	material.emission_enabled = on
	light.visible = on
	if on:
		light.light_bake_mode = Light3D.BAKE_STATIC
	else:
		light.light_bake_mode = Light3D.BAKE_DISABLED
