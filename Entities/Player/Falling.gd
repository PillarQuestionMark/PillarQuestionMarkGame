extends PlayerState

var canDoubleJump : bool

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if(canDoubleJump and Input.is_action_just_pressed("jump")):
		finished.emit(DOUBLE_JUMPING)
	elif(player.is_on_floor()):
		if (player.move_direction != Vector3.ZERO):
			if(Input.is_action_pressed("sprint")):
				finished.emit(SPRINTING)
			else:
				finished.emit(WALKING)
		else:
			finished.emit(IDLE)
		

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.speed = player.Air_Speed
	player.drag = player.Air_Drag
	canDoubleJump = data["canDoubleJump"]

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
