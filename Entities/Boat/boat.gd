extends Node3D

@onready var island_id : int = get_tree().current_scene.island_id ## An id used to identify which island this flame belongs to.

func _on_interactable_on_interacting() -> void:
	EventBus.switch_islands.emit(island_id)
	queue_free()
