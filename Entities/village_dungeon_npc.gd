extends StaticBody3D

@export var flames_required:= 3

@export_multiline var need_abilities_dialogue: Array[String] = [
	"you: ..."
]

@export_multiline var need_flames_dialogue: Array[String] = [
	"you: ..."
]

@export_multiline var complete_dialogue: Array[String] = [
	"you: ..."
]

@onready var island : int = get_tree().current_scene.island

func _on_interactable_on_interacting() -> void:
	if PlayerData.data["max_jumps"] < 2 || PlayerData.data["wall_slide_unlocked"] == false:
		EventBus.dialogue.emit(need_abilities_dialogue)
	else:
		var flames_collected = PlayerData.get_island_flames(island).size()
		if flames_collected < flames_required:
			EventBus.dialogue.emit(need_flames_dialogue)
		else:
			EventBus.dialogue.emit(complete_dialogue)
