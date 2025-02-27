class_name Menu extends CanvasLayer

enum Mouse_Mode_Options {FollowSupermenu, Visible, Captured}
enum Pause_Tree_Options {FollowSupermenu, Pause, Run}

var inSubmenu : bool = false
var hideWhileInSubmenus : bool = true
var mouseMode = Mouse_Mode_Options.FollowSupermenu
var pauseTree = Pause_Tree_Options.FollowSupermenu


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not inSubmenu and Input.is_action_just_pressed("menu"):
		_escape_menu()

# Meant to be called by the supermenu when entering
func _enter_menu() -> void:
	var m = Input.mouse_mode
	match mouseMode:
		Mouse_Mode_Options.Visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Mouse_Mode_Options.Captured:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouseMode = m
	
	var p = get_tree().paused
	match pauseTree:
		Pause_Tree_Options.Pause:
			get_tree().paused = true
		Pause_Tree_Options.Run:
			get_tree().paused = false
	pauseTree = p

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
