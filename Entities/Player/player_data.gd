extends Node
## stores the player's save data, which is accessed in many places between many scenes

## based on documentation from Godot on JSON and FileAccess

var _file
var _file_name = "user://saves//save"
var _file_ending = ".pillar"

var data = {
	"player_position" = [-7, 1, 32],
	"player_rotation" = [0, 0, 0],
	"camera_rotation" = [0, 0, 0],
	"current_scene" = "res://Scenes/Playground.tscn"
}

## reads the save file values into the data dictionary
func load_data() -> void:
	##DirAccess.make_dir_absolute("user://saves/")
	
	var json = JSON.new() ## created for better error messages
	print("save file path: " + _file)
	print(FileAccess.file_exists(_file))
	var file = FileAccess.open(_file, FileAccess.WRITE_READ) ## open the save file
	print(FileAccess.file_exists(_file))
	var save = file.get_as_text() ## get the dictionary from the save file
	print("save:")
	print(save)
	var error = json.parse(save)
	if error == OK:
		print("om")
		data = json.data
	else:
		print("ERROR: ", json.get_error_message(), " at line ", json.get_error_line())
	file.close()
	
	get_tree().change_scene_to_file(data["current_scene"]) ## load the scene

## writes the current data dictionary into the save file
func save_data() -> void:
	## tell the player, and any other saving objects, to save their data
	var save_objects = get_tree().get_nodes_in_group("save")
	for saving in save_objects:
		saving.save()
	
	var save = JSON.stringify(data, "/t") ## turn the data into JSON
	var file = FileAccess.open(_file, FileAccess.WRITE) ## open the save file, should overwrite
	file.store_string(save) ## write the JSON data
	file.close() ## close the file
		
## used when loading the game to signify which file we are playing on
func set_file_number(file : int) -> void:
	_file = _file_name + String.num_int64(file) + _file_ending
	
