extends CanvasLayer

@onready var console_input := %ConsoleInput
@onready var console := %Console

@onready var paused := %Paused
@onready var advance_1_frame := %Advance1Frame
@onready var advance_10_frames := %Advance10Frames

@onready var jump_unlock := %JumpUnlock
@onready var double_jump_unlock := %DoubleJumpUnlock
@onready var sprint_unlock := %SprintUnlock
@onready var dash_unlock := %DashUnlock
@onready var slam_unlock := %SlamUnlock
@onready var wall_slide_unlock := %WallSlideUnlock

@onready var flames: SpinBox = %Flames


func _process(delta: float) -> void:
	paused.button_pressed = get_tree().paused
	advance_1_frame.disabled = not get_tree().paused
	advance_10_frames.disabled = not get_tree().paused
	
	# TODO: set ability unlock controls


func _on_panel_container_on_showing() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	
	console_input.grab_focus()


func _on_panel_container_on_hiding() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_panel_container_on_shown() -> void:
	pass # Replace with function body.


func _on_panel_container_on_hidden() -> void:
	get_tree().paused = false
	visible = false


func _on_paused_toggled(toggled_on: bool) -> void:
	get_tree().paused = toggled_on
	advance_1_frame.disabled = not toggled_on
	advance_10_frames.disabled = not toggled_on


func _on_advance_1_frame_pressed() -> void:
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().paused = true


func _on_advance_10_frames_pressed() -> void:
	get_tree().paused = false
	for i in 10:
		await get_tree().process_frame
	get_tree().paused = true


func _on_jump_unlock_toggled(toggled_on: bool) -> void:
	if not toggled_on: double_jump_unlock.button_pressed = false
	
	PlayerData.data["max_jumps"] = 1 if toggled_on else 0


func _on_double_jump_unlock_toggled(toggled_on: bool) -> void:
	if toggled_on: jump_unlock.button_pressed = true
	
	PlayerData.data["max_jumps"] = 2 if toggled_on else 1


func _on_sprint_unlock_toggled(toggled_on: bool) -> void:
	PlayerData.data["sprint_unlocked"] = toggled_on


func _on_dash_unlock_toggled(toggled_on: bool) -> void:
	PlayerData.data["dash_unlocked"] = toggled_on


func _on_slam_unlock_toggled(toggled_on: bool) -> void:
	PlayerData.data["slam_unlocked"] = toggled_on


func _on_wall_slide_unlock_toggled(toggled_on: bool) -> void:
	PlayerData.data["wall_slide_unlocked"] = toggled_on


func _on_console_input_command(text: String) -> void:
	if text.begins_with("log "):
		console.text += text.trim_prefix("log ") + "\n"


func _on_flames_value_changed(value: float) -> void:
	pass # TODO: set player collected flame count
