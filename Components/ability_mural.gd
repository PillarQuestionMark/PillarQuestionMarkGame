extends CSGBox3D

## dialogue text.
## see dialogue_screen.gd for more info on the format.
@export_multiline var dialogue: Array[String] = [
	"you: fascinating..."
]

@export var unlock : String = "jump"

func _on_interactable_on_interacting() -> void:
	PlayerData.unlock_move(unlock)
	EventBus.dialogue.emit(dialogue)
