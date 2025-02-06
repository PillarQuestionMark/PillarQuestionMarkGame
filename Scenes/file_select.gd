extends Node
## The file select screen, showcasing the player's save files.

var FileContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FileContainer = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer
	FileContainer.get_node("File1").grab_focus()
	
	for file in [1, 2, 3]:
		_read_file(FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending, file)
	
## used to read the save files for menu information
func _read_file(filePath : String, number : int):
	var data = FileUtility.read_file(filePath)
	if (data != null):
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Time: " + FileUtility.get_time_string(data["playtime"])
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = "Flames: " + String.num(data["total_flames"])
	else:
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Empty"
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = ""

## used when a file is pressed. passed an int representing which save file to use
func _on_file_pressed(file : int) -> void:
	PlayerData.set_file_number(file)
	PlayerData.load_data()
	
## used when a file is being deleted. passed an int representing which save file to use
func _on_file_delete(file : int) -> void:
	var deleting = FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending
	FileUtility.delete_file(deleting)
	_read_file(deleting, file)
