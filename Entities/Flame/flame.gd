extends Area3D

@export var flame_name := "Humble Beginnings"

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		pickup()

func pickup() -> void:
	EventBus.flame_found.emit(flame_name)
	queue_free()
