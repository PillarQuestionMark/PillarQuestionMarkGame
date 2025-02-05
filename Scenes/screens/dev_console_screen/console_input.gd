extends LineEdit

signal command(text: String)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter_dev_command"):
		command.emit(text)
		text = ""
