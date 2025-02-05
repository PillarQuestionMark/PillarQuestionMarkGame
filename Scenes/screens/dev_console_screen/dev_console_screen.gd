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


func _ready() -> void:
	Logger.on_logging.connect(_on_logger_logging)


func _on_logger_logging(severity: Logger.LogLevel, message: String) -> void:
	# filtering by loglevel is already done by Logger, so we don't need to do it
	var m := message
	if severity == Logger.LogLevel.DEBUG:
		m = "[color=dim_gray]%s[/color]\n" % m
	elif severity == Logger.LogLevel.INFO:
		m = "[color=white]%s[/color]\n" % m
	elif severity == Logger.LogLevel.WARNING:
		m = "[color=orange]%s[/color]\n" % m
	elif severity == Logger.LogLevel.ERROR:
		m = "[color=red]%s[/color]\n" % m
	console.append_text(m)


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
	console_input.text = "" # prevent picking up random characters


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


func _on_console_input_text_submitted(text: String) -> void:
	console_input.text = ""
	
	if text == "help":
		console.append_text("> help\n")
		console.append_text("help               print help\n")
		console.append_text("debug [lb]MESSAGE[rb]    log debug message\n")
		console.append_text("info  [lb]MESSAGE[rb]    log info message\n")
		console.append_text("warn  [lb]MESSAGE[rb]    log warning message\n")
		console.append_text("error [lb]MESSAGE[rb]    log error message\n")
	elif text.begins_with("debug "):
		Logger.debug(text.trim_prefix("debug "))
	elif text.begins_with("info "):
		Logger.info(text.trim_prefix("info "))
	elif text.begins_with("warn "):
		Logger.warning(text.trim_prefix("warn "))
	elif text.begins_with("error "):
		Logger.error(text.trim_prefix("error "))
	elif text.begins_with("run "):
		var code := text.trim_prefix("run ")
		var e := Expression.new()
		if e.parse(code, ["Logger", "EventBus", "PlayerData"]) != OK:
			console.append_text("[color=red]failed to parse expression \"%s\": %s[/color]\n" % [code, e.get_error_text()])
			return
		var result = e.execute([Logger, EventBus, PlayerData], self)
		if e.has_execute_failed():
			console.append_text("[color=red]failed to execute expression \"%s\": %s[/color]\n" % [code, e.get_error_text()])
			return
		console.append_text("> run %s\n" % code)
		console.append_text("%s\n" % result)
	else:
		console.append_text("[color=red]unknown command \"%s\"[/color]\n" % text)


func _on_flames_value_changed(value: float) -> void:
	pass # TODO: set player collected flame count
