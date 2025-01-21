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
	#Transition states
	if(canDoubleJump and Input.is_action_just_pressed("jump")):
		finished.emit(DOUBLE_JUMPING)
	elif(Input.is_action_pressed("dash") && player.can_dash):
		finished.emit(DASHING)
	elif(player.is_on_floor()):
		if (player.get_move_direction() != Vector3.ZERO):
			if(Input.is_action_pressed("sprint")):
				finished.emit(SPRINTING)
			else:
				finished.emit(WALKING)
		else:
			finished.emit(IDLE)
	#Still here, so do movement
	player.apply_gravity(_delta)
	player.apply_speed_and_drag(player.Air_Speed, player.Air_Drag)
	player.rotate_player(player.get_move_direction(), _delta / player.Rotation_Flux)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	canDoubleJump = data["canDoubleJump"]

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
