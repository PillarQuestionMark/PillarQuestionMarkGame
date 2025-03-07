class_name SaveVersioning
## Helps assure save files are compatible with the current version.

## The current version of save file, to which all outdated save files will be updated to.
const current_version : float = 0

## Updates the save file passed until it is up-to-date.
static func check_version(save : Dictionary) -> bool:
	var updated : bool = false
	## if the save file has no version, start at the beginning
	if (!save.has("version")):
		Callable(SaveVersioning, "_convert_new").call(save)
		Logger.info("Adding file version...")
		updated = true
		
	## keep updating save file until it is up-to-date
	while (save["version"] < current_version):
		var converter = Callable(SaveVersioning, "_convert_" + str(save["version"]))
		if (!converter.is_null()): ## make sure converter exists
			converter.call(save)
			Logger.info("Converting save from version " + str(save["version"]))
			updated = true
		else:
			Logger.error("Could not convert from version " + str(save["version"]))
			
	return updated
		
## if missing field, use save["new_field"] = default
## if obsolete field, ignore it for now... or save.erase("obsolete_field")
## if outdated field, convert it using old data
## Conversion Functions:

## Converts from no version to v0.
static func _convert_new(save : Dictionary) -> void:
	save["version"] = 0
	
