extends Node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("start_game")):
		PlayerData.set_file_number(0)
		PlayerData.load_data()
	if (Input.is_action_just_pressed("quit_game")):
		get_tree().quit()

func _on_start_button_pressed():
	PlayerData.set_file_number(0)
	PlayerData.load_data()

func _on_quit_button_pressed():
	get_tree().quit()
