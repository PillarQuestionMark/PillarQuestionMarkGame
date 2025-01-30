extends CanvasLayer

func _on_cancel_pressed() -> void:
	queue_free()

func _on_apply_pressed() -> void:
	# TODO: save settings
	queue_free()
