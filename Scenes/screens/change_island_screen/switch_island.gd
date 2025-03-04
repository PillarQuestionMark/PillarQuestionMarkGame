extends CanvasLayer

var island_scenes = {"Island1": "res://Scenes/islands/island0/Island0.tscn","Island2" : "res://Scenes/Playground.tscn", "Island3" : "res://Scenes/islands/ruins/ruins_island.tscn"}
var island_checkpoints = {"Island1": 0, "Island2" : 0, "Island3" : 0}
@export var current_island : int = 0
@export var flames_required : int = 0

var _mouse_mode: Input.MouseMode

func _ready() -> void:
	get_tree().paused = true
	Input.mouse_mode = _mouse_mode	

func _on_island_pressed(island_number: String) -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
	if (PlayerData.get_island_flames(current_island).size() >= flames_required):
		PlayerData.call_deferred("load_scene", island_scenes[island_number], island_checkpoints[island_number])
	else:
		Logger.info("NOT ENOUGH FLAMES! YOU NEED " + str(flames_required) + "!")	


func _on_stay_here_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
