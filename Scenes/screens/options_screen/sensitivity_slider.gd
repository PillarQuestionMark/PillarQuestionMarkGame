extends HSlider

enum Profile {
	KEYBOARD_AND_MOUSE,
	CONTROLLER,
}

@export var profile := Profile.KEYBOARD_AND_MOUSE:
	set(value):
		profile = value
		_update_slider()
		
func _reset() -> void:
	_update_slider()

func _ready() -> void:
	_update_slider()
	
func _on_slider_change(value : float) -> void:
	if profile == Profile.KEYBOARD_AND_MOUSE:
		Settings.update_mouse_sensitivity(value)
	else:
		Settings.update_controller_sensitivity(value)
		
func _update_slider() -> void:
	if profile == Profile.KEYBOARD_AND_MOUSE:
		value = Settings.settings["mouse_sensitivity"] / Settings.base_mouse_sensitivity
	else:
		value = Settings.settings["controller_sensitivity"] / Settings.base_controller_sensitivity
		
