extends StaticBody3D


@export_multiline var dialogue: Array[String] = [
	"you: ..."
]


func _on_interactable_on_interacting() -> void:
	EventBus.dialogue.emit(dialogue)
