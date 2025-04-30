extends CSGBox3D

## dialogue text.
## see dialogue_screen.gd for more info on the format.
@export_multiline var dialogue: Array[String] = [
	"you: fascinating..."
]

@export var unlock : String = "jump"

@export var unlock_text : String = "Press {key} to use it"

func _on_interactable_on_interacting() -> void:
	PlayerData.unlock_move(unlock)
	var add : Array[String] = [unlock_text.format({"key": "[color=#FDBEBE]" + Controls.get_single_control(unlock) + "[/color]"})]
	EventBus.dialogue.emit(dialogue + add)
	EventBus.trigger.emit("ability_unlock")
