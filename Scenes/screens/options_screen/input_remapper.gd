## based off of:
## - https://gamedevartisan.com/tutorials/godot-fundamentals/input-remapping
## - https://www.youtube.com/watch?v=ZDPM45cHHlI
extends Button
class_name InteractRemapper

@export var action := ""

enum Profile {
	KEYBOARD_AND_MOUSE,
	CONTROLLER,
}
@export var profile := Profile.KEYBOARD_AND_MOUSE:
	set(value):
		profile = value
		_update_text()

var _is_remapping := false

func _ready() -> void:
	_update_text()


func _update_text() -> void:
	text = ""
	var count := 0
	for e in InputMap.action_get_events(action):
		
		if profile == Profile.KEYBOARD_AND_MOUSE and not _is_event_keyboard_and_mouse(e):
			continue
		
		elif profile == Profile.CONTROLLER and not _is_event_controller(e):
			continue
	
		if count > 0:
			text += ", "
		
		text += e.as_text() if profile == Profile.KEYBOARD_AND_MOUSE else Settings.convert_controller_to_string(e)
		
		#text += e.as_text()
		##text += added
		
		count += 1


func _on_pressed() -> void:
	_is_remapping = true
	text = "..."

func _input(event: InputEvent) -> void:
	
	if not _is_remapping:
		return
	
	# don't bind esc to anything
	if event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			_is_remapping = false
			_update_text()
			return
	
	# don't bind cntroller + to anything
	if event is InputEventJoypadButton:
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_START:
			_is_remapping = false
			_update_text()
			return
	
	if profile == Profile.KEYBOARD_AND_MOUSE and _is_event_keyboard_and_mouse(event):
		_input_keyboard_and_mouse(event)
	
	elif profile == Profile.CONTROLLER and _is_event_controller(event):
		_input_controller(event)


func _is_event_keyboard_and_mouse(event: InputEvent) -> bool:
	if event is InputEventKey:
		return true
	if event is InputEventMouseButton:
		return true
	return false

func _is_event_controller(event: InputEvent) -> bool:
	if event is InputEventJoypadButton:
		return true
	if event is InputEventJoypadMotion and (abs((event as InputEventJoypadMotion).axis_value) > 0.1 or abs((event as InputEventJoypadMotion).axis_value) == 0) :
	##if event is InputEventJoypadMotion:
		return true
	return false

func _input_keyboard_and_mouse(event: InputEvent) -> void:
	
	# erase mouse and keyboard events for the action
	for e in InputMap.action_get_events(action):
		if _is_event_keyboard_and_mouse(e):
			InputMap.action_erase_event(action, e)
	
	InputMap.action_add_event(action, event)
	
	_is_remapping = false
	_update_text()
	get_viewport().set_input_as_handled()

func _input_controller(event: InputEvent) -> void:
	
	# erase controller events for the action
	for e in InputMap.action_get_events(action):
		if _is_event_controller(e):
			InputMap.action_erase_event(action, e)
	
	InputMap.action_add_event(action, event)
	
	_is_remapping = false
	_update_text()
	get_viewport().set_input_as_handled()
