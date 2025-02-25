class_name Menu extends CanvasLayer

var inSubmenu : bool = false
var hideWhileInSubmenus : bool = true

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not inSubmenu and Input.is_action_just_pressed("menu"):
		_escape_menu()

# Called specifically through the escape key (as of now)
# Override this method for desired function
func _escape_menu() -> void:
	queue_free()

# Meant to be called by the supermenu when entering
func _enter_menu() -> void:
	pass

# Used by the menu itself when exiting
func _exit_menu() -> void:
	queue_free()

func _enter_submenu(submenu) -> void:
	var s : Menu = submenu.instantiate()
	add_child(s)
	s.tree_exited.connect(_exit_submenu)
	
	# Could have used visible to indicate when in a submenu,
	# but I could forsee reasons you would want these separate.
	inSubmenu = true
	if hideWhileInSubmenus : visible = false

# Connects to the tree_exited signal
func _exit_submenu() -> void:
	inSubmenu = false
	if hideWhileInSubmenus : visible = true
