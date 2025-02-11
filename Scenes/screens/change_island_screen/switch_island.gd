extends CanvasLayer

var island_scenes = {"Island1": "res://Scenes/Playground.tscn","Island2" : "res://Scenes/Playground.tscn"}
var island_coords = {"Island1": {"x": 0, "y": 0, "z": 0}, "Island2" : {"x": 0, "y": 0, "z": 0}}

func _ready() -> void:
	get_tree().paused = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().paused = false
		queue_free()

func _on_island_pressed(extra_arg_0: String) -> void:
	pass # Replace with function body.
