extends Menu

const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
const FLAME_LIST_SCREEN := preload("res://Scenes/screens/flame_list_screen/flame_list_screen.tscn")
const ABILITY_LIST_SCREEN := preload("res://Scenes/screens/abilities_screen/abilities_list_screen.tscn")

func _ready() -> void:
	Logger.info("pausescreen: ready")
	pauseTree = Pause_Tree_Options.Pause
	mouseMode = Mouse_Mode_Options.Visible
	_enter_menu()

func _escape_menu() -> void:
	Logger.info("pausescreen: escaped menu")
	super()

func _on_resume_pressed() -> void:
	Logger.info("pausescreen: resume button pressed")
	AudioManager.play_fx("button")
	_exit_menu()

func _on_options_pressed() -> void:
	Logger.info("pausescreen: options button pressed")
	AudioManager.play_fx("button")
	_enter_submenu(OPTIONS_SCREEN)

func _on_quit_pressed() -> void:
	Logger.info("pausescreen: save and quit button pressed")
	AudioManager.play_fx("button")
	PlayerData.save_data()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	_exit_menu()
	
func _on_flames_list_pressed() -> void:
	Logger.info("pausescreen: flames list button pressed")
	AudioManager.play_fx("button")
	_enter_submenu(FLAME_LIST_SCREEN)
	
func _on_abilities_list_pressed() -> void:
	Logger.info("pausescreen: ability list button pressed")
	AudioManager.play_fx("button")
	_enter_submenu(ABILITY_LIST_SCREEN)
	
