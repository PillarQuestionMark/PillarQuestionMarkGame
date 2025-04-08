extends Menu
## The file select screen, showcasing the player's save files.

var FileContainer ## Reference to a node to base UI elements off of.

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.debug("Entered File Select")
	_enter_menu()
	FileContainer = %FileContainer
	
	## this should not happen thanks to file versioning
	## if it is needed; let me know! - Seven
	## uncomment the below line to delete all saves upon entering file select
	## this is done when the save files will crash the file select and need to be deleted
	## please comment it again after you use it once, otherwise it will continue deleting
	## delete_all_saves()
	
	for file in [1, 2, 3]:
		_read_file(FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending, file)

func _set_focus() -> void:
	%FileContainer/File1.grab_focus()

## Reads the given file number and writes the important data onto the given save file slot.
func _read_file(filePath : String, number : int):
	var data = FileUtility.read_file(filePath)
	if (data != null):
		if (SaveVersioning.check_version(data)):
			FileUtility.write_file(filePath, data)
			data = FileUtility.read_file(filePath)
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Time: " + FileUtility.get_time_string(data["playtime"])
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = "Flames: " + String.num(data["total_flames"])
	else:
		FileContainer.get_node("File" + String.num_int64(number) + "/Time").text = "Empty"
		FileContainer.get_node("File" + String.num_int64(number) + "/Flames").text = ""

## Called when a file is pressed. The function is passed an int representing which save file to play.
func _on_file_pressed(file : int) -> void:
	PlayerData.set_file_number(file)
	PlayerData.load_data()
	AudioManager.play_fx("button")
	AudioManager.stop_music() # not sure if this should go here :/
	AudioManager.play_music("feet")
	
## Called when a file is being deleted. The function is passed an int representing which save file to delete.
func _on_file_delete(file : int) -> void:
	var deleting = FileUtility.save_file_name + String.num_int64(file) + FileUtility.save_file_ending
	FileUtility.delete_file(deleting)
	AudioManager.play_fx("button")
	_read_file(deleting, file)

## dev function used to delete all save files. useful for save file changes that crash the game
func delete_all_saves() -> void:
	for file in [1, 2, 3]:
		_on_file_delete(file)
