extends CanvasLayer

func _ready() -> void:
	Logger.info("optionsscreen: ready")

func _on_cancel_pressed() -> void:
	Logger.info("optionsscreen: cancel pressed")
	AudioManager.play_fx("button")
	queue_free()

func _on_apply_pressed() -> void:
	# TODO: save settings
	Logger.info("optionsscreen: apply button pressed")
	AudioManager.play_fx("button")
	queue_free()

func _on_option_button_item_selected(index: int) -> void:
	Logger.info("optionsscreen: control scheme changed to %s" % index)
	AudioManager.play_fx("button")
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
