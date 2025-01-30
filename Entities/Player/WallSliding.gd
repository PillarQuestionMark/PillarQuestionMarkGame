extends PlayerState

var slide_timer : Timer = Timer.new()

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	print("erm")
	
	if (!player.is_on_wall_only()):
		_end_slide()
		
	if (Input.is_action_just_pressed("jump")):
		player.velocity = player.get_wall_normal() * player.Wall_Kick
		finished.emit(JUMPING, {"canDoubleJump" = false})
		player.can_wall_slide = true
		var normal = player.get_wall_normal()
		normal.y = 0 ## helps avoid strange rotations on edge cases
		## for some reason, this sometimes gets an error otherwise...
		if (player.position != player.position + normal):
			player.get_pivot().look_at_from_position(player.position, player.position + normal, Vector3.UP)
	elif (Input.is_action_just_pressed("slam") && player.slam_unlocked):
		finished.emit(SLAMMING)
		
	player.apply_gravity(_delta / player.Slide_Gravity_Factor)
	player.apply_speed_and_drag(player.Air_Speed, player.Air_Drag)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	## adds a timer to keep track of the dash duration
	slide_timer = Timer.new()
	player.add_child(slide_timer)
	slide_timer.wait_time = 1
	slide_timer.one_shot = true
	slide_timer.timeout.connect(_end_slide)
	slide_timer.start()
	
	player.can_wall_slide = false
	
	player.wall_slide_particles.emitting = true

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	if (slide_timer != null):
		slide_timer.queue_free()
	
	player.wall_slide_particles.emitting = false
	
func _end_slide() -> void:
	finished.emit(FALLING, {"canDoubleJump" : false})
