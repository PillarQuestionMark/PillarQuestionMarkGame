extends Node

func _ready() -> void:
	EventBus.flame_found.connect(_on_flame_collected)
	EventBus.dialogue.connect(_on_dialogue)
	EventBus.switch_islands.connect(_on_island_switch)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		const PAUSE_SCREEN := preload("res://Scenes/screens/pause_screen/pause_screen.tscn")
		var s := PAUSE_SCREEN.instantiate()
		_show_screen(s)

func _on_flame_collected(name: String, color: Color, id : float) -> void:
	const FLAME_COLLECTED_SCREEN := preload("res://Scenes/screens/flame_collected_screen/flame_collected_screen.tscn")
	var s := FLAME_COLLECTED_SCREEN.instantiate()
	s.flame_name = name
	s.flame_color = color
	_show_screen(s)
	
func _on_island_switch(current_island: IslandData.Islands) -> void:
	const ISLAND_SWITCH_SCREEN := preload("res://Scenes/screens/change_island_screen/change_island_screen.tscn")
	var s := ISLAND_SWITCH_SCREEN.instantiate()
	s.current_island = current_island
	
	# manually change current_scene
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(s)
	get_tree().current_scene = s

func _on_dialogue(dialogue: Array[String]) -> void:
	const DIALOGUE_SCREEN := preload("res://Scenes/screens/dialogue_screen/dialogue_screen.tscn")
	var s := DIALOGUE_SCREEN.instantiate()
	s.dialogue = dialogue
	_show_screen(s)

func _show_screen(screen: Node) -> void:
	get_tree().root.add_child(screen)
