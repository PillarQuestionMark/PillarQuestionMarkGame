extends Node

func _ready() -> void:
	EventBus.dialogue.connect(_on_dialogue)
	#pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		const PAUSE_SCREEN := preload("res://Scenes/screens/pause_screen/pause_screen.tscn")
		get_tree().root.add_child(PAUSE_SCREEN.instantiate())

func _on_dialogue(dialogue: Array[String]) -> void:
	const DIALOGUE_SCREEN := preload("res://Scenes/screens/dialogue_screen/dialogue_screen.tscn")
	var s := DIALOGUE_SCREEN.instantiate()
	s.dialogue = dialogue
	get_tree().root.add_child(s)
