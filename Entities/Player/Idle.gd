extends PlayerState

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	## friction, otherwise stores momentum until next jump
	player.velocity *= Vector3(0.8, 1, 0.8)
	
	#Transition States
	if(!player.is_on_floor()):
		finished.emit(FALLING, {"canDoubleJump" : true})
	elif(Input.is_action_just_pressed("jump")):
		finished.emit(JUMPING)
	elif(Input.is_action_just_pressed("dash") && player.can_dash):
		finished.emit(DASHING)
	elif(player.get_move_direction() != Vector3.ZERO):
		if(Input.is_action_pressed("sprint")):
			finished.emit(SPRINTING)
		else:
			finished.emit(WALKING)
			
	player.apply_gravity(_delta)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.touched_ground()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
