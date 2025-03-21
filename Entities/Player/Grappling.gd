extends PlayerState

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if(true): # 
		# Here is where grapple hook pull happens
		# Skip all state changes, still in pulling stage
		player.apply_gravity(_delta)
		player.move_and_slide()
		return
	
	if(!player.is_on_floor()):
		finished.emit(FALLING)
	elif(Input.is_action_just_pressed("jump") and player.jumps_left > 0):
		player.jumps_left -= 1
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
	
	player.apply_gravity(_delta)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	var search := %GrappleRange
	var bestDest : GrappleablePoint = null
	for dest : Area3D in search.get_overlapping_areas():
		var ray := RayCast3D.new()
		ray.collide_with_areas = true
		ray.collision_mask = 33
		ray.target_position = dest.position
		ray.force_raycast_update()
		if ray.get_collider() != null:
			pass
	
	if bestDest == null:
		pass
	

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
