extends Area2D
class_name Interactable2D


signal on_interacting

func interact() -> void:
	Logger.info("interactable2d %s: interacted" % get_path())
	on_interacting.emit()
