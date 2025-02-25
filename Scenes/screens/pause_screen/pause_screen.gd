extends Menu

const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")

func _ready() -> void:
	get_tree().paused = true
	Logger.info("pausescreen: ready")

func _escape_menu() -> void:
	Logger.info("pausescreen: escaped menu")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_exit_menu()

func _on_resume_pressed() -> void:
	Logger.info("pausescreen: resume button pressed")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_exit_menu()


func _on_options_pressed() -> void:
	Logger.info("pausescreen: options button pressed")
	_enter_submenu(OPTIONS_SCREEN)

func _on_quit_pressed() -> void:
	Logger.info("pausescreen: save and quit button pressed")
	PlayerData.save_data()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	_exit_menu()
