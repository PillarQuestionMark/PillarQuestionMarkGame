extends PlayerState

var canDoubleJump : bool

var coyote_timer : Timer
var jump_held : bool = false
var held_boost : Vector3 

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	## jump held mechanic
	if (jump_held && Input.is_action_pressed("jump")):
		player.velocity += held_boost
		held_boost *= player.Jump_Held_Decay ## diminishing returns for holding jump boost
		print("held boost!")
	else:
		jump_held = false
	
	#Transition states
	if(Input.is_action_just_pressed("jump") and player.jumps_left > 0):
		player.jumps_left -= 1
		finished.emit(JUMPING)
	elif(player.can_wall_slide && player.velocity.y < 0 && player.is_on_wall_only()):
		finished.emit(WALL_SLIDING)
	elif(Input.is_action_just_pressed("dash") && player.can_dash):
		finished.emit(DASHING)
	elif (Input.is_action_just_pressed("slam") && PlayerData.data["slam_unlocked"]):
		finished.emit(SLAMMING)
	elif(player.is_on_floor()):
		if (player.get_move_direction() != Vector3.ZERO):
			if(Input.is_action_pressed("sprint") && PlayerData.data["sprint_unlocked"]):
				finished.emit(SPRINTING)
			else:
				finished.emit(WALKING)
		else:
			finished.emit(IDLE)
	elif (Input.is_action_just_pressed("interact")):
		player.try_interact()
	#Still here, so do movement
	player.apply_gravity(_delta)
	player.apply_speed_and_drag(player.Air_Speed, player.Air_Drag)
	player.rotate_player(player.get_move_direction(), _delta / player.Rotation_Flux)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if (previous_state_path == "Jumping" or previous_state_path == "Slamjumping"):
		jump_held = true
		held_boost = Vector3(0, player.Jump_Held_Strength, 0)
	else:
		## adds a timer to keep track of the dash duration
		coyote_timer = Timer.new()
		player.add_child(coyote_timer)
		coyote_timer.wait_time = player.Coyote_Time
		coyote_timer.one_shot = true
		coyote_timer.timeout.connect(_end_coyote_timer)
		coyote_timer.start()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
	
func _end_coyote_timer() -> void:
	player.jumps_left -= 1
	print("anvil time")
