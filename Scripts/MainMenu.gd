extends Node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("start_game")):
		get_tree().change_scene_to_file("res://Scenes/Playground.tscn")
	if (Input.is_action_just_pressed("quit_game")):
		get_tree().quit()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Playground.tscn")

func _on_options_button_pressed() -> void:
	const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
	var s := OPTIONS_SCREEN.instantiate()
	get_tree().root.add_child(s)
	
	# hide current screen and restore it when the options screen goes away
	$CanvasLayer.visible = false
	s.tree_exited.connect(func(): $CanvasLayer.visible = true)

func _on_quit_button_pressed():
	get_tree().quit()
