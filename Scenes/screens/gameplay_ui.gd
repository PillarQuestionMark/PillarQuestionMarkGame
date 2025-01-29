extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		const PAUSE_SCREEN := preload("res://Scenes/screens/pause_screen/pause_screen.tscn")
		get_tree().root.add_child(PAUSE_SCREEN.instantiate())
