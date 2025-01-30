extends CanvasLayer

func _on_cancel_pressed() -> void:
	queue_free()

func _on_apply_pressed() -> void:
	# TODO: save settings
	queue_free()

func _on_option_button_item_selected(index: int) -> void:
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
