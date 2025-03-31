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
		if _is_ready: _update_on()

const default_material = preload("res://Scenes/props/lantern/lantern_material_default.tres")
@export var material: StandardMaterial3D = default_material:
	set(value):
		material = value
		update_configuration_warnings()
		if _is_ready:
			_update_material()
			_update_on() # update emission_enabled

@export_group("Internal")
@export var _surface_material_override_idx := 0 ## index of surface material override to use as the colored lantern material

@onready var _light: OmniLight3D = $OmniLight3D

var _is_ready := false # prevent setters from accessing child nodes before _ready() is done

func _ready() -> void:
	_is_ready = true
	_update_material()
	_update_on()

#func _update_color() -> void:
	#material.albedo_color = color
	#material.emission = color
	#_light.light_color = color

func _update_on() -> void:
	#material.emission_enabled = on # causes issues with shared materials. instead, use separate materials for on/off lanterns.
	_light.visible = on
	if on:
		_light.light_bake_mode = Light3D.BAKE_STATIC
	else:
		_light.light_bake_mode = Light3D.BAKE_DISABLED

func _update_material() -> void:
	set_surface_override_material(_surface_material_override_idx, material)
	
	# update light color based on material
	_light.light_color = material.albedo_color

func _get_configuration_warnings() -> PackedStringArray:
	if material == default_material:
		return ["Set the lantern material to something other than the default, e.g. lantern_material_off_c33c40.tres."]
	return []
