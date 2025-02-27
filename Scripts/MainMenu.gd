extends Node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AudioManager.play_music("main_menu")
	Logger.info("mainmenu: ready")

func _on_start_button_pressed():
	Logger.info("mainmenu: start button pressed")
	AudioManager.play_fx("button")
	get_tree().change_scene_to_file("res://Scenes/file_select.tscn")

func _on_options_button_pressed() -> void:
	Logger.info("mainmenu: options button pressed")
	AudioManager.play_fx("button")
	const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
	var s := OPTIONS_SCREEN.instantiate()
	get_tree().root.add_child(s)
	
	# hide current screen and restore it when the options screen goes away
	$CanvasLayer.visible = false
	s.tree_exited.connect(func(): $CanvasLayer.visible = true)

func _on_quit_button_pressed():
	Logger.info("mainmenu: quit button pressed")
	get_tree().quit()
