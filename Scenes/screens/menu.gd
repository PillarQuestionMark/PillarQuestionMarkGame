class_name Menu extends CanvasLayer

enum Mouse_Mode_Options {FollowSupermenu, Visible, Captured}
enum Pause_Tree_Options {FollowSupermenu, Pause, Run}

var inSubmenu : bool = false
var hideWhileInSubmenus : bool = true
var mouseMode = Mouse_Mode_Options.FollowSupermenu
var pauseTree = Pause_Tree_Options.FollowSupermenu

var currentMouseMode = Mouse_Mode_Options.FollowSupermenu


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not inSubmenu and (Input.is_action_just_pressed("menu") || Input.is_action_just_pressed("ui_cancel")):
		_escape_menu()

# Meant to be called by the supermenu when entering
func _enter_menu() -> void:
	currentMouseMode = mouseMode
	
	set_mouse()
	EventBus.control_switch.connect(_update_mouse)
	
	var p = get_tree().paused
	match pauseTree:
		Pause_Tree_Options.Pause:
			get_tree().paused = true
		Pause_Tree_Options.Run:
			get_tree().paused = false
	pauseTree = p
	
	_set_focus()
	
func _update_mouse() -> void:
	if (currentMouseMode == Mouse_Mode_Options.Visible):
		if (Settings.control_scheme == Settings.Profile.KEYBOARD_AND_MOUSE):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	
func set_mouse() -> void:
	var m = Input.mouse_mode
	match mouseMode:
		Mouse_Mode_Options.Visible:
			if (Settings.control_scheme == Settings.Profile.KEYBOARD_AND_MOUSE):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Mouse_Mode_Options.Captured:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouseMode = m

# Called specifically through the escape key (as of now)
# Override this method for desired function
func _escape_menu() -> void:
	Input.mouse_mode = mouseMode
	get_tree().paused = pauseTree
	queue_free()

# Used by the menu itself when exiting
func _exit_menu() -> void:
	Input.mouse_mode = mouseMode
	get_tree().paused = pauseTree
	queue_free()

func _enter_submenu(submenu) -> void:
	var s : Menu = submenu.instantiate()
	add_child(s)
	s.tree_exited.connect(_exit_submenu)
	
	inSubmenu = true
	if hideWhileInSubmenus : visible = false

# Connects to the tree_exited signal
func _exit_submenu() -> void:
	inSubmenu = false
	if hideWhileInSubmenus : visible = true
	_set_focus()
	
## Changes the menu focus when a button is hovered over.
func _on_hovered_button(hovered : String = "Resume") -> void:
	var button = find_child(hovered)
	if button != null:
		button.grab_focus()
	
## Sets the controller focus for the menu
func _set_focus() -> void:
	pass
	
