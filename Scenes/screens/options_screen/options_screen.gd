extends Menu

func _ready() -> void:
	Logger.info(name + ": ready")
	_enter_menu()
	if Settings.control_scheme == Settings.Profile.CONTROLLER:
		_on_option_button_item_selected(1)
		%OptionButton.selected = 1

func _escape_menu() -> void:
	Logger.info(name + ": escaped menu")
	super()

func _on_cancel_pressed() -> void:
	Settings.load_settings()
	Logger.info("optionsscreen: cancel pressed")
	AudioManager.play_fx("button")
	_exit_menu()

func _on_apply_pressed() -> void:
	Settings.save()
	Logger.info("optionsscreen: apply button pressed")
	AudioManager.play_fx("button")
	EventBus.rebind.emit()
	_exit_menu()

func _on_option_button_item_selected(index: int) -> void:
	Logger.info("optionsscreen: control scheme changed to %s" % index)
	AudioManager.play_fx("button")
	if index == 0: # keyboard + mouse
		%InteractRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%JumpRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%DashRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%SlamRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%GrappleRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%SprintRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%SensitivitySlider.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
	else: # controller
		%InteractRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%JumpRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%DashRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%SlamRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%GrappleRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%SprintRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%SensitivitySlider.profile = InteractRemapper.Profile.CONTROLLER

func _set_focus() -> void:
	%Cancel.grab_focus()
