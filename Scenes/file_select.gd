extends Node

var _file_name = "user://save"
var _file_ending = ".pillar"

var FileContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FileContainer = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer
	FileContainer.get_node("File1").grab_focus()
	
	for file in [1, 2, 3]:
		_read_file(_file_name + String.num_int64(file) + _file_ending, file)
	
## used to read the save files for menu information
func _read_file(filePath : String, number : int):
	var save
	var json = JSON.new() ## created for better error messages
	if (FileAccess.file_exists(filePath)):
		var file = FileAccess.open(filePath, FileAccess.READ) ## open the save file
		save = file.get_as_text() ## get the dictionary from the save file
		file.close()
	else:
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Empty"
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = ""
		return
		
	var error = json.parse(save)
	if error == OK:
		var data = json.data
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Time: " + _convert_time(data["playtime"])
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = "Flames: " + String.num(data["collected_flames"].size())
	else:
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Empty"
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = ""
		print("ERROR: ", json.get_error_message(), " at line ", json.get_error_line())


## converts the playtime in seconds to a more viewable format
func _convert_time(time : int) -> String:
	var seconds
	var minutes
	var hours
	
	## get the seconds
	seconds = String.num_int64(time % 60).pad_zeros(2)
	time /= 60 ## move to minutes
	
	## get the minutes, if any
	minutes = String.num_int64(time % 60).pad_zeros(2)
	time /= 60 ## move to hours
	
	if (time > 0):
		hours = String.num_int64(time)
	else:
		hours = "0"
	
	return hours + ":" + minutes + ":" + seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## used when a file is pressed. passed an int representing which save file to use
func _on_file_pressed(file : int) -> void:
	PlayerData.set_file_number(file)
	PlayerData.load_data()
	
## used when a file is being deleted. passed an int representing which save file to use
func _on_file_delete(file : int) -> void:
	var deleting = _file_name + String.num_int64(file) + _file_ending
	## this should just move the deleted safe file to the trash
	if (FileAccess.file_exists(deleting)):
		OS.move_to_trash(ProjectSettings.globalize_path(deleting)) 
	## DirAccess.remove_absolute(deleting) this will PERMANENTLY delete the file
	_read_file(_file_name + String.num_int64(file) + _file_ending, file)
