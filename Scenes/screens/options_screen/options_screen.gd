extends Menu

func _ready() -> void:
	Logger.info(name + ": ready")
	_enter_menu()

func _escape_menu() -> void:
	Logger.info(name + ": escaped menu")
	super()

func _on_cancel_pressed() -> void:
	Logger.info("optionsscreen: cancel pressed")
	_exit_menu()

func _on_apply_pressed() -> void:
	# TODO: save settings
	Logger.info("optionsscreen: apply button pressed")
	_exit_menu()

func _on_option_button_item_selected(index: int) -> void:
	Logger.info("optionsscreen: control scheme changed to %s" % index)
	if index == 0: # keyboard + mouse
		%InteractRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%JumpRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%DashRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
		%SlamRemapper.profile = InteractRemapper.Profile.KEYBOARD_AND_MOUSE
	else: # controller
		%InteractRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%JumpRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%DashRemapper.profile = InteractRemapper.Profile.CONTROLLER
		%SlamRemapper.profile = InteractRemapper.Profile.CONTROLLER
