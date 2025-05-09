extends PlayerState

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if (Input.is_action_just_pressed("interact")):
		player.try_interact()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if previous_state_path != WALL_SLIDING:
		player.jumps_left -= 1
	AudioManager.play_fx("jump")
	player.velocity.y = player.Jump_Impulse
	finished.emit(FALLING)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
