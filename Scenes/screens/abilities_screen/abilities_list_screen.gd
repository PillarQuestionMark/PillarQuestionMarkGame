extends Menu

@onready var container = get_node("PanelContainer/CenterContainer/VBoxContainer")
@onready var back_button = get_node("PanelContainer/CenterContainer/VBoxContainer/back")

var abilities : Dictionary = {
	"sprint_unlocked" : "sprint",
	"dash_unlocked" : "dash",
	"slam_unlocked" : "slam",
	"wall_slide_unlocked" : "wall slide",
	"grapple_unlocked" : "grapple"
}

func _ready() -> void:
	_print_abilities()
	Logger.info("abilitylistscreen: ready")
	pauseTree = Pause_Tree_Options.Pause
	mouseMode = Mouse_Mode_Options.Visible
	_enter_menu()

func _escape_menu() -> void:
	Logger.info("abilitylistscreen: escaped menu")
	super()

func _on_resume_pressed() -> void:
	Logger.info("abilitylistscreen: resume button pressed")
	AudioManager.play_fx("button")
	_exit_menu()
	
func _print_abilities() -> void:
	
	_print_label("jump", PlayerData.data["max_jumps"] > 0)
	_print_label("double jump", PlayerData.data["max_jumps"] > 1)
	for move in abilities.keys():
		_print_label(abilities[move], PlayerData.data[move])
	
	container.add_child(Label.new())
	container.move_child(back_button, container.get_child_count() - 1)
	
func _print_label(move : String, unlocked : bool) -> void:
	if (!unlocked):
		move = "???"
		
	var lable = Label.new()
	lable.text = move
	lable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(lable)
	
func _set_focus() -> void:
	%back.grab_focus()
