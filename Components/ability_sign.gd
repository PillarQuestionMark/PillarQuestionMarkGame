extends CSGBox3D

## dialogue text.
## see dialogue_screen.gd for more info on the format.
@export_multiline var dialogue: Array[String] = [
	"you: fascinating..."
]

@export var ability : String = "jump"

@export var ability_text : String = "sign: try holding {key} to sprint!!"

func _on_interactable_on_interacting() -> void:
	var add : Array[String] = [ability_text.format({"key": "[color=#FDBEBE]" + Settings.get_single_control(ability) + "[/color]"})]
	EventBus.dialogue.emit(dialogue + add)
