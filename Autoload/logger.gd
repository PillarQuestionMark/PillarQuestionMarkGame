## based off of https://www.nightquestgames.com/logger-in-gdscript-for-better-debugging/
extends Node

var use_console := true
var use_logfile := false
var loglevel := LogLevel.DEBUG

enum LogLevel {
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3,
}

signal on_logging(severity: LogLevel, message: String)

var _logfile: FileAccess = null

func _ready() -> void:
	var timestamp := _timestamp()
	var timestamp_filesafe := timestamp.replace(":", "-").replace(" ", "_") # replace illegal file name characters
	
	# log overall info
	info("logger: timestamp = %s" % timestamp)
	info("logger: use_console = %s" % use_console)
	info("logger: use_logfile = %s" % use_logfile)
	info("logger: loglevel = %s" % LogLevel.keys()[loglevel])
	
	if use_logfile:
		var logfile_path = "user://%s.log" % timestamp_filesafe
		debug("logger: opening logfile %s" % ProjectSettings.globalize_path(logfile_path))
		_logfile = _open_logfile(logfile_path)
		debug("logger: logfile opened")
	
	info("logger: ready")

func debug(message: String) -> void:
	if loglevel > LogLevel.DEBUG: return
	var m := "[%s DEBUG] %s" % [_timestamp(), message]
	on_logging.emit(LogLevel.DEBUG, m)
	_print(m)

func info(message: String) -> void:
	if loglevel > LogLevel.INFO: return
	var m := "[%s INFO ] %s" % [_timestamp(), message]
	on_logging.emit(LogLevel.INFO, m)
	_print(m)

func warning(message: String) -> void:
	if loglevel > LogLevel.WARNING: return
	var m := "[%s WARN ] %s" % [_timestamp(), message]
	on_logging.emit(LogLevel.WARNING, m)
	_print(m)

func error(message: String) -> void:
	if loglevel > LogLevel.ERROR: return
	var m := "[%s ERROR] %s" % [_timestamp(), message]
	on_logging.emit(LogLevel.ERROR, m)
	_print(m)

## returns the current date and time
## e.g. "2025-02-03 12:30:08"
func _timestamp() -> String:
	var t := Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d %02d:%02d:%02d" % [t.year, t.month, t.day, t.hour, t.minute, t.second]

## like _timestamp(), but avoids characters that can't be in file names
func _timestamp_filesafe() -> String:
	var t := Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d_%02d-%02d-%02d" % [t.year, t.month, t.day, t.hour, t.minute, t.second]

func _open_logfile(path: String) -> FileAccess:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		_print("logger: failed to open logfile: %s" % FileAccess.get_open_error(), true)
		get_tree().quit(1)
	return f

## prints a message to the console and/or the log file
func _print(message: String, is_error := false) -> void:
	if use_console:
		if is_error:
			printerr(message)
		else:
			print(message)
	if use_logfile and _logfile != null:
		_logfile.store_line(message)
