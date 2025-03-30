extends PlayerState

var targetPosition : Vector3

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if(player.global_position.distance_squared_to(targetPosition) > 1.0 and Input.is_action_pressed("grapple")):
		# Here is where grapple hook pull happens
		# Skip all state changes, still in pulling stage
		var direction = player.global_position.direction_to(targetPosition)
		player.velocity = direction * player.Grapple_Speed
		player.move_and_slide()
		return
	
	if(!player.is_on_floor()):
		finished.emit(FALLING)
	elif(Input.is_action_just_pressed("jump") and player.jumps_left > 0):
		if player.can_slamjump():
			finished.emit(SLAMJUMPING)
		else:
			finished.emit(JUMPING)
	elif(Input.is_action_just_pressed("dash") and player.can_dash):
		finished.emit(DASHING)
	elif(player.get_move_direction() != Vector3.ZERO):
		if(Input.is_action_pressed("sprint") and PlayerData.data["sprint_unlocked"]):
			finished.emit(SPRINTING)
		else:
			finished.emit(WALKING)
	elif (Input.is_action_just_pressed("interact")):
		player.try_interact()
	else:
		finished.emit(IDLE)

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	var bestDest : GrappleablePoint = %GrappleTargetLocator.get_best_target()
	if bestDest == null:
		# TODO: This works for now, but it could have unexpected consequences.
		# Should probably just switch out here.
		targetPosition = player.global_position
		return
	targetPosition = bestDest.global_position

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
