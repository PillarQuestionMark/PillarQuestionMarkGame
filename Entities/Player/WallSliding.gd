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
		finished.emit(FALLING)
		
	if (Input.is_action_just_pressed("jump") and player.jumps_left > 0):
		player.jumps_left -= 1
		player.velocity = player.velocity/2 + player.get_wall_normal() * player.Wall_Kick
		#player.velocity += player.get_wall_normal() * player.Wall_Kick # fun mode
		finished.emit(JUMPING)
		player.can_wall_slide = true
		var normal = player.get_wall_normal()
		normal.y = 0 ## helps avoid strange rotations on edge cases
		## for some reason, this sometimes gets an error otherwise...
		if (player.position != player.position + normal):
			player.get_pivot().look_at_from_position(player.position, player.position + normal, Vector3.UP)
	elif (Input.is_action_just_pressed("slam") && player.slam_unlocked):
		finished.emit(SLAMMING)
		
	player.apply_gravity(_delta / player.Slide_Gravity_Factor)
	player.apply_speed_and_drag(player.Air_Speed, 0)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.can_wall_slide = false
	player.wall_slide_particles.emitting = true

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	if (slide_timer != null):
		slide_timer.queue_free()
	
	player.wall_slide_particles.emitting = false
