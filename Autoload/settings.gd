extends Node

var base_controller_sensitivity = 0.5
var base_mouse_sensitivity = 0.05

var controller_sensitivity = 0.5
var mouse_sensitivity = 0.05

func update_mouse_sensitivity(multiplier : float) -> void:
	mouse_sensitivity = base_mouse_sensitivity * multiplier
	EventBus.sensitivity_update.emit()
	print(mouse_sensitivity)
	
func update_controller_sensitivity(multiplier : float) -> void:
	controller_sensitivity = base_controller_sensitivity * multiplier
	EventBus.sensitivity_update.emit()
	print(str(controller_sensitivity) + " CONTROLLER!")
