class_name Controls
## Holds details on the input controls.

static func get_single_control(action : String) -> String:
	return get_control(action).get_slice(",", 0)
	
static func get_control(action : String) -> String:
	if (action == "double_jump" || action == "wall_slide"): # double jump, wall jump and jump are the same key
		action = "jump"
	var text = ""
	var count := 0
	for e in InputMap.action_get_events(action):
		
		if Settings.control_scheme == Settings.Profile.KEYBOARD_AND_MOUSE and not _is_event_keyboard_and_mouse(e):
			continue
		
		elif Settings.control_scheme == Settings.Profile.CONTROLLER and not _is_event_controller(e):
			continue
	
		if count > 0:
			text += ", "
		
		text += e.as_text() if Settings.control_scheme == Settings.Profile.KEYBOARD_AND_MOUSE else convert_controller_to_string(e)
		
		count += 1
		
	return text

static func _is_event_keyboard_and_mouse(event: InputEvent) -> bool:
	if event is InputEventKey:
		return true
	if event is InputEventMouseButton:
		return true
	return false

static func _is_event_controller(event: InputEvent) -> bool:
	if event is InputEventJoypadButton:
		return true
	if event is InputEventJoypadMotion and (abs((event as InputEventJoypadMotion).axis_value) > 0.1 or abs((event as InputEventJoypadMotion).axis_value) == 0) :
	##if event is InputEventJoypadMotion:
		return true
	return false
	
## Converts the long annoying input string to a simple name
static func convert_controller_to_string(event) -> String:
	var result = event.as_text()
	result = result.get_slice("(", 1) ## remove parenthesis
	result = result.get_slice(")", 0)
	if (event is InputEventJoypadButton):
		result = result.get_slice(",", 0)
	elif (event is InputEventJoypadMotion):
		result = result.get_slice(",", 0 if event.axis < 4 else 1)
		
	return result
