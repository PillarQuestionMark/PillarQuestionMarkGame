extends Node

func _ready() -> void:
	EventBus.flame_found.connect(_on_flame_collected)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		const PAUSE_SCREEN := preload("res://Scenes/screens/pause_screen/pause_screen.tscn")
		var s := PAUSE_SCREEN.instantiate()
		_show_screen(s)

func _on_flame_collected(flame_name: String) -> void:
	const FLAME_COLLECTED_SCREEN := preload("res://Scenes/screens/flame_collected_screen/flame_collected_screen.tscn")
	var s := FLAME_COLLECTED_SCREEN.instantiate()
	s.flame_name = flame_name
	_show_screen(s)

func _show_screen(screen: Node) -> void:
	get_tree().root.add_child(screen)
