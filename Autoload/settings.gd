extends Node

enum Profile {
	KEYBOARD_AND_MOUSE,
	CONTROLLER,
}

@export var control_scheme := Profile.KEYBOARD_AND_MOUSE:
	set(value):
		control_scheme = value
		EventBus.control_switch.emit()
		print("CONTROL SCHEME CHANGED!")

# settings file
var _file = "user://settings.pillar"

# Sensitivity
var base_controller_sensitivity = 0.5
var base_mouse_sensitivity = 0.05

# Normal Settings
var settings = {
	"fullscreen" = false,
	"mouse_sensitivity" = 0.05,
	"controller_sensitivity" = 0.05,
	"volume" = 1,
	"music" = 1,
	"effects" = 1
}

func load_settings() -> void:
	_get_data()
	
	## set audio levels
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(settings["volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(settings["music"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(settings["effects"]))
	
	_set_mouse_sensitivity(settings["mouse_sensitivity"])
	_set_controller_sensitivity(settings["controller_sensitivity"])
	
func _get_data() -> void:
	var data = FileUtility.read_file(_file)
	if (data == null):
		data = settings
		save() # add the settings file
	data.merge(settings) ## should fix any issues for missing settings
	settings = data
	
func save() -> void:
	FileUtility.write_file(_file, settings)

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	if (Input.get_connected_joypads().size() > 0):
		control_scheme = Profile.CONTROLLER
		
	load_settings()

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
