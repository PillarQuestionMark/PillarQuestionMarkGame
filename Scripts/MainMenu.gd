extends CanvasLayer

@onready var main: Control = $Main

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("start_game")):
		get_tree().change_scene_to_file("res://Scenes/Playground.tscn")
	if (Input.is_action_just_pressed("quit_game")):
		get_tree().quit()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Playground.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
