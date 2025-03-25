extends Menu

const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
const FILE_MENU := preload("res://Scenes/file_select.tscn")

func _ready() -> void:
	Logger.info("mainmenu: ready")
	pauseTree = Pause_Tree_Options.Run
	mouseMode = Mouse_Mode_Options.Visible
	AudioManager.play_music("main_menu")
	_enter_menu()

func _escape_menu() -> void:
	_on_quit_button_pressed()

func _on_start_button_pressed() -> void:
	Logger.info("mainmenu: start button pressed")
	AudioManager.play_fx("button")
	_enter_submenu(FILE_MENU)

func _on_options_button_pressed() -> void:
	Logger.info("mainmenu: options button pressed")
	AudioManager.play_fx("button")
	_enter_submenu(OPTIONS_SCREEN)

func _on_quit_button_pressed() -> void:
	Logger.info("mainmenu: quit button pressed")
	AudioManager.play_fx("button")
	get_tree().quit()
