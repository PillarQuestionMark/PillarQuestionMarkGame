extends CanvasLayer


var _mouse_mode: Input.MouseMode

func _ready() -> void:
	get_tree().paused = true
	Logger.info("pausescreen: ready")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		_on_resume_pressed()


func _on_resume_pressed() -> void:
	Logger.info("pausescreen: resume button pressed")
	AudioManager.play_fx("button")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_options_pressed() -> void:
	Logger.info("pausescreen: options button pressed")
	AudioManager.play_fx("button")
	const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
	var s := OPTIONS_SCREEN.instantiate()
	get_tree().root.add_child(s)
	
	# hide current screen and restore it when the options screen goes away
	visible = false
	s.tree_exited.connect(func(): visible = true)


func _on_quit_pressed() -> void:
	Logger.info("pausescreen: save and quit button pressed")
	AudioManager.play_fx("button")
	PlayerData.save_data()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	queue_free()
