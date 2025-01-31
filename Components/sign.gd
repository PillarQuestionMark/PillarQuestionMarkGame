extends CSGBox3D

## dialogue text.
## see dialogue_screen.gd for more info on the format.
@export var dialogue: Array[String] = [
	"you: fascinating..."
]


func _on_interactable_on_interacting() -> void:
	EventBus.dialogue.emit(dialogue)
