extends Node

enum Profile {
	KEYBOARD_AND_MOUSE,
	CONTROLLER,
}

@export var control_scheme := Profile.KEYBOARD_AND_MOUSE:
	set(value):
		control_scheme = value
		EventBus.control_switch.emit()
		print("CONTROL SCHEME CHANGED! CURRENT MOUSE MODE: " + str(mouse_mode))
		_set_mouse()

# settings file
var _file = "user://settings.pillar"

# Sensitivity
var base_controller_sensitivity = 0.5
var base_mouse_sensitivity = 0.05

# Mouse
var mouse_mode : Input.MouseMode = Input.MOUSE_MODE_VISIBLE:
	set(value):
		mouse_mode = value
		_set_mouse()
		print("MOUSE MODE SET TO " + str(value))

# Normal Settings
var settings = {
	"fullscreen" = false,
	"mouse_sensitivity" = 0.05,
	"controller_sensitivity" = 0.05,
	"volume" = 1,
	"music" = 1,
	"effects" = 1,
	"interact" = [["InputEventKey", 70], ["InputEventJoypadButton", 3]],
	"jump" = [["InputEventKey", 32], ["InputEventKey", 4194438], ["InputEventJoypadButton", 0]],
	"dash" = [["InputEventKey", 4194306], ["InputEventMouseButton", 2], ["InputEventJoypadMotion", 5]],
	"slam" = [["InputEventKey", 69], ["InputEventJoypadButton", 1]],
	"grapple" = [["InputEventKey", 81], ["InputEventJoypadMotion", 4]]
}

var action_binds = ["interact", "jump", "dash", "slam", "grapple"]

## Saves current binding into settings
func _write_action_binds() -> void:
	for action in action_binds: # save each action
		settings[action].clear() # avoid stacking
		for bind in InputMap.action_get_events(action): 
			_save_action(action, bind)

## Sets the binds from settings to game
func _set_action_binds() -> void:
	## use settings for each remappable action
	for action in action_binds:
		InputMap.action_erase_events(action) # clear all default bindings
		
		## add all the saved bindings
		for bind in settings[action]:
			_add_action(action, bind[0], bind[1]) # add bind

## Saves an action to the settings dictionary
func _save_action(action : String, event : InputEvent) -> void:
	var bind : Array = []
	if (event is InputEventKey):
		bind = ["InputEventKey", event.keycode]
	elif (event is InputEventMouseButton):
		bind = ["InputEventMouseButton", event.button_index]
	elif (event is InputEventJoypadButton):
		bind = ["InputEventJoypadButton", event.button_index]
	elif (event is InputEventJoypadMotion):
		bind = ["InputEventJoypadMotion", event.axis]
		
	settings[action].append(bind)

## Adds an action to the input map
func _add_action(action : String, type : String, code : int) -> void:
	var event = null
	match type:
		"InputEventKey":
			event = InputEventKey.new()
			event.keycode = code
		"InputEventMouseButton":
			event = InputEventMouseButton.new()
			event.button_index = code
		"InputEventJoypadButton":
			event = InputEventJoypadButton.new()
			event.button_index = code
		"InputEventJoypadMotion":
			event = InputEventJoypadMotion.new()
			event.axis = code
	
	if (event != null):
		InputMap.action_add_event(action, event)
	else:
		Logger.debug("ERROR ADDING INPUT ACTION TO MAP")


# action:
# 	type - code
#	type - code

func _set_mouse() -> void:
	if mouse_mode == Input.MOUSE_MODE_VISIBLE && control_scheme == Profile.KEYBOARD_AND_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func load_settings() -> void:
	_get_data()
	
	## set audio levels
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(settings["volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(settings["music"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(settings["effects"]))
	
	_set_mouse_sensitivity(settings["mouse_sensitivity"])
	_set_controller_sensitivity(settings["controller_sensitivity"])
	
	_set_action_binds()
	
func _get_data() -> void:
	var data = FileUtility.read_file(_file)
	if (data == null):
		data = settings
		save() # add the settings file
	data.merge(settings) ## should fix any issues for missing settings
	settings = data
	
func save() -> void:
	_write_action_binds()
	FileUtility.write_file(_file, settings)

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	if (Input.get_connected_joypads().size() > 0):
		control_scheme = Profile.CONTROLLER
		
	load_settings()
	
	_set_mouse()
	
	print("INTERACT START:")
	for e in InputMap.action_get_events("interact"):
		print(e)
	print("INTERACT END.")

func update_mouse_sensitivity(multiplier : float) -> void:
	_set_mouse_sensitivity(base_mouse_sensitivity * multiplier)
	
func _set_mouse_sensitivity(value : float) -> void:
	settings["mouse_sensitivity"] = value
	EventBus.sensitivity_update.emit()
	
func update_controller_sensitivity(multiplier : float) -> void:
	_set_controller_sensitivity(base_controller_sensitivity * multiplier)
	
func _set_controller_sensitivity(value : float) -> void:
	settings["controller_sensitivity"] = value
	EventBus.sensitivity_update.emit()
	
## checks if using controller or keyboard
func _input(event) -> void:
	##print("READING AMNDY")
	if control_scheme != Profile.KEYBOARD_AND_MOUSE && (event is InputEventMouse || event is InputEventKey):
		control_scheme = Profile.KEYBOARD_AND_MOUSE
	##if control_scheme != Profile.CONTROLLER && (event is InputEventJoypadButton || event is InputEventJoypadMotion):
	# technically the above if statement is correct, but my controller is broken so the below works better - Seven
	if !event.is_action("sprint") && (control_scheme != Profile.CONTROLLER && (event is InputEventJoypadButton || event is InputEventJoypadMotion)):
		if event is InputEventJoypadMotion:
			if abs((event as InputEventJoypadMotion).axis_value) < 0.1:
				return
		control_scheme = Profile.CONTROLLER
		print(event)
