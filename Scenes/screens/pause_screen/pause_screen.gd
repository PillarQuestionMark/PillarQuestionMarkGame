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
	pass # TODO: options menu


func _on_quit_pressed() -> void:
	get_tree().quit() # TODO: save
