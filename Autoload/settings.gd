extends Node

enum Profile {
	KEYBOARD_AND_MOUSE,
	CONTROLLER,
}

@export var control_scheme := Profile.KEYBOARD_AND_MOUSE:
	set(value):
		control_scheme = value
		EventBus.control_switch.emit()

var base_controller_sensitivity = 0.5
var base_mouse_sensitivity = 0.05

var controller_sensitivity = 0.5
var mouse_sensitivity = 0.05

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	if (Input.get_connected_joypads().size() > 0):
		control_scheme = Profile.CONTROLLER

func update_mouse_sensitivity(multiplier : float) -> void:
	mouse_sensitivity = base_mouse_sensitivity * multiplier
	EventBus.sensitivity_update.emit()
	
func update_controller_sensitivity(multiplier : float) -> void:
	controller_sensitivity = base_controller_sensitivity * multiplier
	EventBus.sensitivity_update.emit()
	
func _input(event) -> void:
	##print("READING AMNDY")
	if control_scheme != Profile.KEYBOARD_AND_MOUSE && (event is InputEventMouse || event is InputEventKey):
		control_scheme = Profile.KEYBOARD_AND_MOUSE
	##if control_scheme != Profile.CONTROLLER && (event is InputEventJoypadButton || event is InputEventJoypadMotion):
	# technically the above if statement is correct, but my controller is broken so the below works better - Seven
	if !Input.is_action_pressed("sprint") && (control_scheme != Profile.CONTROLLER && (event is InputEventJoypadButton || event is InputEventJoypadMotion)):
		control_scheme = Profile.CONTROLLER
