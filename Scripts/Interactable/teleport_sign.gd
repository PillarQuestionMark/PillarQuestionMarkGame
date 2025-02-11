extends Node3D

@export var Scene : String = "res://Scenes/Playground.tscn"
@export var checkpoint: int = 0
@export var flames_required : int = 0

@onready var island : int = get_tree().current_scene.island_id ## An id used to identify which island this flame belongs to.

func _on_interactable_on_interacting() -> void:
	if (PlayerData.get_island_flames(island).size() >= flames_required):
		PlayerData.call_deferred("load_scene", Scene, checkpoint)
	else:
		Logger.info("NOT ENOUGH FLAMES! YOU NEED " + str(flames_required) + "!")
