extends Menu

const OPTIONS_SCREEN := preload("res://Scenes/screens/options_screen/options_screen.tscn")

@onready var container = get_node("PanelContainer/CenterContainer/VBoxContainer")
@onready var back_button = get_node("PanelContainer/CenterContainer/VBoxContainer/back")
var current_island : IslandData.Islands = IslandData.Islands.None

func _ready() -> void:
	_print_flames()
	Logger.info("flamelistscreen: ready")
	pauseTree = Pause_Tree_Options.Pause
	mouseMode = Mouse_Mode_Options.Visible
	_enter_menu()

func _escape_menu() -> void:
	Logger.info("flamelistscreen: escaped menu")
	super()

func _on_resume_pressed() -> void:
	Logger.info("flamelistscreen: resume button pressed")
	AudioManager.play_fx("button")
	_exit_menu()
	
func set_island(island_id : IslandData.Islands) -> void:
	current_island = island_id
	
func _print_flames() -> void:
	EventBus.request_island_id.emit(Callable(self, "set_island"))
	if (current_island == IslandData.Islands.None):
		var lable = Label.new()
		lable.text = "There seems to be no flames around..."
		container.add_child(lable)
	else:
		var collected_flames = PlayerData.get_island_flames(current_island)
		var lable = Label.new()
		lable.text = str(collected_flames.size()) + "/" + str(FlameIndex.island_total_flames(current_island))
		lable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		container.add_child(lable)
		
		for flame in FlameIndex.get_flame_ids(current_island):
			var flame_lable = Label.new()
			if (collected_flames.has(float(flame))):
				flame_lable.text = ("- " + FlameIndex.get_flame_name(current_island, flame))
			else:
				flame_lable.text = ("- ???")
			container.add_child(flame_lable)
		
	container.move_child(back_button, container.get_child_count() - 1)
