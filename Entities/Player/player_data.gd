extends Node
## stores the player's save data, which is accessed in many places between many scenes

## based on documentation from Godot on JSON and FileAccess

var _file
var _file_name = "user://save"
var _file_ending = ".pillar"

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
	##_write_default() ## used for writing the default file (DO NOT UNCOMMENT UNLESS YOU KNOW WHAT THIS DOES)
	var save
	var json = JSON.new() ## created for better error messages
	if (FileAccess.file_exists(_file)):
		var file = FileAccess.open(_file, FileAccess.READ) ## open the save file
		save = file.get_as_text() ## get the dictionary from the save file
		file.close()
	else:
		var default_file = FileAccess.open("res://default_save.pillar", FileAccess.READ)
		var file = FileAccess.open(_file, FileAccess.WRITE_READ) ## open the save file
		save = default_file.get_as_text() ## get the default data
		file.store_line(save) ## save the default data to the new file
		default_file.close()
		file.close()
	
	var error = json.parse(save)
	if error == OK:
		data = json.data
	else:
		Logger.error("playerdata: json error at line %s: %s" % [json.get_error_line(), json.get_error_message()])
	
	get_tree().change_scene_to_file(data["current_scene"]) ## load the scene
	
	start_time = Time.get_unix_time_from_system()

## writes the current data dictionary into the save file
func save_data() -> void:
	## THIS BELOW MAY NOT BE NEEDED ANYMORE
	## tell the player, and any other saving objects, to save their data
	var save_objects = get_tree().get_nodes_in_group("save")
	for saving in save_objects:
		saving.save()
		
	## get playtime
	data["playtime"] += Time.get_unix_time_from_system() - start_time
	
	var save = JSON.stringify(data, "\t") ## turn the data into JSON
	var file = FileAccess.open(_file, FileAccess.WRITE) ## open the save file, should overwrite
	file.store_line(save) ## write the JSON data
	file.close() ## close the file
		
## used when loading the game to signify which file we are playing on
func set_file_number(file : int) -> void:
	_file = _file_name + String.num_int64(file) + _file_ending
	
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
	
	
## dev function used to write the default save file when changes are made
func _write_default() -> void:
	## open the default save to write
	var default_file = FileAccess.open("res://default_save.pillar", FileAccess.WRITE)
	## get the default data seen above
	var save = JSON.stringify(data, "\t")
	## write the default data to the save
	default_file.store_line(save)
	## close the default file
	default_file.close()
	
## called when you die to reload scene, as well as travelling between scenes
func load_scene() -> void:
	get_tree().change_scene_to_file(data["current_scene"]) ## load the scene
