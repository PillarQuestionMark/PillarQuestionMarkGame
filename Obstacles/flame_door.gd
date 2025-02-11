class_name FlameDoor extends Node3D

@export var flames_required : int = 1 ## Number of flames required to open the door.
@export var island_id : int = 0 ## The island of the dungeon door.

## dialogue text.
## see dialogue_screen.gd for more info on the format.
@export_multiline var dialogue: Array[String] = [
	"you: fascinating..."
]

@onready var island : int = get_tree().current_scene.island_id ## An id used to identify which island this flame belongs to.

func _on_interactable_on_interacting() -> void:
	if (PlayerData.get_island_flames(island).size() >= flames_required):
		queue_free()
		PlayerData.data["open_dungeons"].append(float(island)) ## float cast to avoid loading issues
	else:
		EventBus.dialogue.emit(dialogue)
		
