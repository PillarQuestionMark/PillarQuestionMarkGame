extends CanvasLayer

var scene_to_load : String = "res://Scenes/islands/ruins/ruins_island.tscn"
var fade_finished : bool = false
var load_finished : bool = false
var show_label : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/details.visible = false
	$PanelContainer2/Sprite2D.visible = false
	$PanelContainer/ColorRect.color.a = 0
	fade_finished = false
	load_finished = false

func start_load(next_scene : String) -> void:
	scene_to_load = next_scene
	
	Logger.info("LOADING: " + str(next_scene))
	## load the next scene in the background
	ResourceLoader.load_threaded_request(scene_to_load)
	
	var color_goal = $PanelContainer/ColorRect.color
	color_goal.a = 1
	var fade := create_tween()
	fade.tween_property($PanelContainer/ColorRect, "color", color_goal, 0.25)
	await fade.finished
	show_label = true
	fade_finished = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!load_finished):
		_process_load()


func _process_load() -> void:
	var load_progress = ResourceLoader.load_threaded_get_status(scene_to_load)
	## test if loaded
	if (load_progress == ResourceLoader.THREAD_LOAD_LOADED && fade_finished):
		_finish_load()
	else:
		if (show_label):
			$PanelContainer/details.visible = true
			$PanelContainer2/Sprite2D.visible = true
		
	## used for avoiding issues
	if (load_progress == ResourceLoader.THREAD_LOAD_FAILED):
		Logger.error("LOAD FAILED!")
		get_tree().quit()
	if (load_progress == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE):
		Logger.error("LOAD INVALID!")
		get_tree().quit()
		
func _finish_load() -> void:
	get_tree().paused = false
	load_finished = true
	$PanelContainer/details.visible = false
	$PanelContainer2/Sprite2D.visible = false
	Logger.info("LOAD FINISHED!")
	var loaded_scene = ResourceLoader.load_threaded_get(scene_to_load)
	get_tree().change_scene_to_packed(loaded_scene)
	
	var color_goal = $PanelContainer/ColorRect.color
	color_goal.a = 0
	var fade := create_tween()
	fade.tween_property($PanelContainer/ColorRect, "color", color_goal, 0.25)
	await fade.finished
	fade_finished = true
	queue_free()
	
