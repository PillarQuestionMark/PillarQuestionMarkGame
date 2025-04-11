extends Node

signal flame_found(name: String, color: Color, id : float)

## interactables/interactors with the same trigger name affect each other
signal trigger(name: String)

## shows the dialogue screen.
## each element of the text array is a page of dialogue
## (press interact key to go to next page).
## see dialogue_screen.gd for more info on the format.
signal dialogue(dialogue: Array[String])
signal dialogue_finished

## shows the island map screen.
signal switch_islands(current_island: IslandData.Islands)

## used to get current island id without a connection to the Scene
signal request_island_id(return_function : Callable)
## Used for updating sensitivity
signal sensitivity_update()

## Used for better controls switching
signal control_switch()

func _ready() -> void:
	Logger.info("eventbus: ready")
