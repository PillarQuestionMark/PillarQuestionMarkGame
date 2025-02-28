extends Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	mouseMode = Mouse_Mode_Options.Visible
	pauseTree = Pause_Tree_Options.Pause
	_enter_menu()
