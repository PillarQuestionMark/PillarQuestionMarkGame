extends PlayerState

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	#Transition States
	if(!player.is_on_floor()):
		finished.emit(FALLING)
	elif(Input.is_action_just_pressed("jump") and player.jumps_left > 0):
		if player.can_slamjump():
			finished.emit(SLAMJUMPING)
		else:
			finished.emit(JUMPING)
	elif(Input.is_action_just_pressed("grapple") and PlayerData.data["grapple_unlocked"]):
		finished.emit(GRAPPLING)
	elif(Input.is_action_just_pressed("dash") and player.can_dash):
		finished.emit(DASHING)
	elif(player.get_move_direction() == Vector3.ZERO):
		finished.emit(IDLE)
	elif(!Input.is_action_pressed("sprint")):
		finished.emit(WALKING)
	elif (Input.is_action_just_pressed("interact")):
		player.try_interact()
	
	#Still here, so move
	player.apply_gravity(_delta)
	player.apply_speed_and_drag(player.Sprint_Speed, player.Ground_Drag)
	player.rotate_player(player.get_move_direction(), _delta * player.Rotation_Flux)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.touched_ground()
	player.wall_slide_particles.emitting = true

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	player.wall_slide_particles.emitting = false
