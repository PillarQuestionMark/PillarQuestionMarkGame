extends Node
## stores the player's save data, which is accessed in many places between many scenes

## based on documentation from Godot on JSON and FileAccess

var _file

var start_time

## dictionary of data (default values to be overwritten)
var data = {
	"playtime" = 0.0, ## playtime for the save file
	"total_flames" = 0,
	"collected_flames" = {}, ## id of all collected flames, sorted by island id
	"collected_fragments" = [], ## id of collected fragments from dungeons (final prize)
	"open_dungeons" = [], ## id of dungeons opened already
	"current_scene" = "res://Scenes/Playground.tscn", ## scene the player is in (or moving to)
	"checkpoint" = 0, ## checkpoint in current scene
	"max_jumps" = 0,
	"dash_unlocked" = false,
	"sprint_unlocked" = false,
	"slam_unlocked" = false,
	"wall_slide_unlocked" = false
}

## reads the save file values into the data dictionary
func load_data() -> void:
	## used for writing the default file (DO NOT UNCOMMENT UNLESS YOU KNOW WHAT THIS DOES)
	##FileUtility.write_file("res://default_save.pillar", data)

	if (FileAccess.file_exists(_file)):
		data = FileUtility.read_file(_file)
	else:
		data = FileUtility.read_file("res://default_save.pillar")
		FileUtility.write_file(_file, data)
	
	get_tree().change_scene_to_file(data["current_scene"]) ## load the scene
	
	start_time = Time.get_unix_time_from_system()

## Writes the current data dictionary into the save file.
func save_data() -> void:
	## get playtime
	data["playtime"] += Time.get_unix_time_from_system() - start_time
	FileUtility.write_file(_file, data)
		
## used when loading the game to signify which file we are playing on
func set_file_number(file : int) -> void:
	_file = FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending
	
## called when a flame is collected
func flame_collected(flame_id: int, island_id: int):
	## get list of flames and add the newly collected flame
	get_island_flames(island_id).append(flame_id)
	data["total_flames"] += 1
	
## used to get the list of flames on an island
func get_island_flames(island_id: int) -> Array:
	## if the flames dictionary has the island already, just return that list
	## else, create the island entry with an empty list
	return data["collected_flames"].get_or_add(String.num_int64(island_id), [])
	
