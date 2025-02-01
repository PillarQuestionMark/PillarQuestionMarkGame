extends CanvasLayer


var _mouse_mode: Input.MouseMode

func _ready() -> void:
	get_tree().paused = true


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		_on_resume_pressed()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_options_pressed() -> void:
	const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")
	var s := OPTIONS_SCREEN.instantiate()
	get_tree().root.add_child(s)
	
	# hide current screen and restore it when the options screen goes away
	visible = false
	s.tree_exited.connect(func(): visible = true)


func _on_quit_pressed() -> void:
	PlayerData.save_data()
	get_tree().quit() # TODO: save
