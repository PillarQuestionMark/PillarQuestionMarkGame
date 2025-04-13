extends Node3D

@export var trigger := ""


func _on_interactable_on_interacting() -> void:
	EventBus.trigger.emit(trigger)
