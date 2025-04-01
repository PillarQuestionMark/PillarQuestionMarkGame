extends Node3D

func _on_interactable_on_interacting() -> void:
	EventBus.switch_islands.emit(get_tree().current_scene.island)
