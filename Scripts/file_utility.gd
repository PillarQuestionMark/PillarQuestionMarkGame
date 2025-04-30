class_name FileUtility
## Utility functions used with file accessing throughout project.

static var save_file_name = "user://save" ## The beginning of the save file path.
static var save_file_ending = ".pillar" ## The ending of the save file path.

## Reads the given JSON file from file_name, and returns the dictionary of data.
## Returns null if there is an error reading the file or the file does not exist.
static func read_file(file_name : String): # intentional no return type
	var file_data
	var data = null
	var json = JSON.new() ## created for better error messages
	if (FileAccess.file_exists(file_name)):
		var file = FileAccess.open(file_name, FileAccess.READ) ## open the save file
		file_data = file.get_as_text() ## get the dictionary from the save file
		file.close()
		
		var error = json.parse(file_data)
		if error == OK:
			data = json.data
		else:
			Logger.error("fileutility: json error at line %s: %s" % [json.get_error_line(), json.get_error_message()])
		
	return data
	
## Takes a dictionary of data and writes it to the given file in JSON format.
static func write_file(file_name : String, data : Dictionary) -> void:
	var save = JSON.stringify(data, "\t") ## turn the data into JSON
	var file = FileAccess.open(file_name, FileAccess.WRITE) ## open the save file, should overwrite
	file.store_line(save) ## write the JSON data
	file.close() ## close the file
	
## Deletes the designated file.
static func delete_file(file_name : String) -> void:
	## this should just move the deleted safe file to the trash
	if (FileAccess.file_exists(file_name)):
		OS.move_to_trash(ProjectSettings.globalize_path(file_name)) 
		
	## this will PERMANENTLY delete the file
	##if (FileAccess.file_exists(file_name)):
		##DirAccess.remove_absolute(file_name)

## Returns a string representing the int time parameter in HH:MM:SS format.
static func get_time_string(time : int) -> String:
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
