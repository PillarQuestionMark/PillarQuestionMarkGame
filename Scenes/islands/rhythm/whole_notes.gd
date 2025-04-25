class_name WholeNotes extends Node3D

var count: int
var platforms: Array[CSGBox3D] = []
var platform_toggle: bool

func _ready() -> void:
	count = 0
	platform_toggle = true
	for child in get_children():
		if child is CSGBox3D:
			platforms.append(child)

func _on_rhythm_timer_timeout() -> void:
	if not platforms.is_empty():
		count = count + 1
		if count % 4 == 0:
			if count == 8:
				count = 0
			platform_toggle = not platform_toggle
			AudioManager.play_fx("Thump1")
			if platform_toggle:
				set_process(true)
				for platform in platforms:
					platform.transparency = 0
					platform.set_collision_layer_value(1, true)
			else:
				set_process(false)
				for platform in platforms:
					platform.transparency = 0.9
					platform.set_collision_layer_value(1, false)
