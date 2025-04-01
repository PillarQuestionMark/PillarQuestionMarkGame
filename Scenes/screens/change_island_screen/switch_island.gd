extends Menu

var island_scenes = {"Island1": "res://Scenes/islands/island0/Island0.tscn","Island2" : "res://Scenes/Playground.tscn"}
var island_checkpoints = {"Island1": 0, "Island2" : 0}
@export var current_island : int = 0
@export var flames_required : int = 0

func _ready() -> void:
	pauseTree = Pause_Tree_Options.Pause
	mouseMode = Mouse_Mode_Options.Visible
	_enter_menu()
	# TODO: is this the way?
	PhysicsServer2D.set_active(true) # see https://forum.godotengine.org/t/how-can-i-pause-the-scene-but-have-process-mode-nodes-still-process-physics/26271/2

func _on_island_pressed(island_number: String) -> void:
	if (PlayerData.get_island_flames(current_island).size() >= flames_required):
		PlayerData.call_deferred("load_scene", island_scenes[island_number], island_checkpoints[island_number])
	else:
		Logger.info("NOT ENOUGH FLAMES! YOU NEED " + str(flames_required) + "!")
	_exit_menu()


func _on_stay_here_pressed() -> void:
	_exit_menu()
