extends PlayerState

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if(Input.is_action_just_pressed("grapple")):
		finished.emit(GRAPPLING)
	elif (Input.is_action_just_pressed("dash") && player.can_dash):
		finished.emit(DASHING)
	elif (player.is_on_floor()):
		player.start_slamjump_window()
		finished.emit(IDLE)
	elif (Input.is_action_just_pressed("interact")):
		player.try_interact()
	
	player.apply_gravity(_delta * player.Slam_Gravity_Factor)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector3.ZERO

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
