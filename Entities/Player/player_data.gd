extends Node
## Stores the player's save data, which is accessed in many places between many scenes.

# based on documentation from Godot on JSON and FileAccess

var _file = "user://test_save.pillar" ## default to a testing save
## test save used if file select skipped. does not load ever
var _default_file_path = "user://default_save.pillar"

var start_time : float ## The time at which the save file is opened, or last saved. Used for playtime calculations.

signal movementUnlocked(data : String, value)

## Dictionary of player data (default values to be overwritten).
var data = {
	"playtime" = 0.0, ## playtime for the save file
	"total_flames" = 0,
	"collected_flames" = {}, ## id of all collected flames, sorted by island id
	"collected_fragments" = [], ## id of collected fragments from dungeons (final prize) -- UNUSED CURRENTLY
	"open_dungeons" = [], ## id of dungeons opened already -- UNUSED CURRENTLY
	"current_scene" = "res://Scenes/screens/cutscene-screen/cutscene-screen.tscn", ## scene the player is in (or moving to)
	"checkpoint" = 0, ## checkpoint in current scene
	"max_jumps" = 0,
	"dash_unlocked" = false,
	"sprint_unlocked" = true,
	"slam_unlocked" = false,
	"wall_slide_unlocked" = false,
	"grapple_unlocked" = false,
	"version" = 3,
	"cleared_dungeons" = [] ## id of islands where dungeon has been cleared
}

## When loading the game, test if we are using run current scene.
## Used for improving the "run current scene" experience.
func _ready() -> void:
	## main scene : res://Scenes/screens/photo_splash_screen/photo_splash_screen.tscn
	var parent = get_parent()
	create_default_save()
	if (!parent.has_node("PhotoSplashScreen")): ## CHANGE IF FIRST SCENE CHANGES!
		load_data(false) ## do not load a scene, but load everything else
		if (SaveVersioning.check_version(data)): ## update if out-of-date file
			FileUtility.write_file(_file, data)
			data = FileUtility.read_file(_file)
		data["current_scene"] = get_tree().current_scene.scene_file_path

## Reads the save file values into the data dictionary.
func load_data(load_scene : bool = true) -> void:
	## used for writing the default file (DO NOT UNCOMMENT UNLESS YOU KNOW WHAT THIS DOES)
	## this should not even be needed anymore with file versioning. let me know if it is necessary - Seven
	##FileUtility.write_file("res://default_save.pillar", data)
	var default_data = FileUtility.read_file(_default_file_path)
	if (FileAccess.file_exists(_file)):
		data = FileUtility.read_file(_file)
		if data["version"] != default_data["version"]:
			update_data(data)
			FileUtility.write_file(_file, data)
	else:
		data = default_data
		FileUtility.write_file(_file, data)
		## btw, removing the save versioning here may be dangerous
		## this now runs into synchronocity issues if versioning and this data is out of sync
	
	if (load_scene): load_scene()
	
	start_time = Time.get_unix_time_from_system()

## Writes the current data dictionary into the save file.
## This can be called before quitting the game, as well as as an autosave function.
func save_data() -> void:
	## get playtime
	data["playtime"] += Time.get_unix_time_from_system() - start_time
	FileUtility.write_file(_file, data)
	start_time = Time.get_unix_time_from_system()

func update_data(updating_data : Dictionary) -> void:
	var default_data = FileUtility.read_file(_default_file_path)
	updating_data.merge(default_data)

func create_default_save() -> void:
	data["playtime"] = 0
	FileUtility.write_file(_default_file_path, data)

## Used when loading the game to signify which file we are playing on
func set_file_number(file : int) -> void:
	_file = FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending

## Updates the player's save data to include the given flame.
func flame_collected(flame_id: float, island_id: int):
	print("flame: " + str(flame_id) + " island: " + String.num_int64(island_id))
	## get list of flames and add the newly collected flame
	get_island_flames(island_id).append(flame_id)
	data["total_flames"] += 1
	save_data() ## autosave

## Returns the list of flames collected on an island - based on island id.
func get_island_flames(island_id: int) -> Array:
	## if the flames dictionary has the island already, just return that list
	## else, create the island entry with an empty list
	return data["collected_flames"].get_or_add(String.num_int64(island_id), [])

## Loads the player into the given scene at the given checkpoint.
## If no scene and checkpoint passed, it will default to the saved data.
## If scene and checkpoint passed, it will update the save file.
func load_scene(next_scene : String = data["current_scene"], checkpoint : int = data["checkpoint"]) -> void:
	data["current_scene"] = next_scene
	data["checkpoint"] = checkpoint
	
	get_tree().paused = true ## pauses physics... looks nicer
	const LOADING_SCREEN := preload("res://Scenes/screens/loading_screen/loading_screen.tscn")
	var s := LOADING_SCREEN.instantiate()
	s.start_load(next_scene)
	get_tree().root.add_child(s)
	##get_tree().change_scene_to_file(next_scene) ## load the scene
	
## Loads up a cutscene and sets up the cutscene.
func load_cutscene(text : Array[String], scene : String, checkpoint : int) -> void:
	const CUTSCENE := preload("res://Scenes/screens/cutscene-screen/cutscene-screen.tscn")
	var s := CUTSCENE.instantiate()
	s.text = text
	s.next_scene = scene
	s.next_checkpoint = checkpoint
	
	# manually change current_scene
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(s)
	get_tree().current_scene = s

## load_scene() but it uses the IslandData.Islands enum
func load_island(island: IslandData.Islands, checkpoint: int) -> void:
	var island_scene_path := IslandData.get_scene_path_from_island(island)
	load_scene(island_scene_path, checkpoint)

## Sets the checkpoint to spawn at in player data. 
## Separate from [method load_scene] for collecting checkpoints without loading a scene.
## If you also want to load a scene, use [method load_scene].
func update_checkpoint(checkpoint : int):
	data["checkpoint"] = checkpoint

## Unlocks the given ability in the player save. The string must match exactly the data string. [br]
## Normal Jump = "jump" [br]
## Double Jump = "double_jump" [br]
## Dash = "dash" [br]
## Slam = "slam" [br]
## Wall Slide = "wall_slide" [br]
## Grappling hook = "grapple" [br]
func unlock_move(move : String) -> void:
	match move:
		"jump": ## error checking to avoid losing double jump
			if (data["max_jumps"] < 1):
				data["max_jumps"] = 1
				movementUnlocked.emit("max_jumps", 1)
		"double_jump": ## no error checking needed.
			data["max_jumps"] = 2
			movementUnlocked.emit("max_jumps", 2)
		_: ## default case, not handled differently
			data[move + "_unlocked"] = true
			movementUnlocked.emit(move + "_unlocked", true)
	Logger.info("playerdata: unlocked " + move)
