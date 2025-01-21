extends PlayerState

var _direction : Vector3 = Vector3.ZERO
var dash_timer : Timer

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	player.velocity = _direction * player.Dash_Speed
		
	if (Input.is_action_pressed("jump")):
		finished.emit(JUMPING, {"canDoubleJump" : false})
	elif (Input.is_action_pressed("slam")):
		finished.emit(SLAMMING)
		
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = 0
	_direction = player.get_move_direction()
	if (_direction == Vector3.ZERO):
		_direction = -player.get_pivot().basis.z
	_direction.y = 0.0
	player.get_pivot().look_at(player.position + _direction, Vector3.UP)
	player.can_dash = false
	
	## adds a timer to keep track of the dash duration
	var dash_timer = Timer.new()
	player.add_child(dash_timer)
	dash_timer.wait_time = player.Dash_Length
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_finish_dash)
	dash_timer.start()
	
	print("pikmin 5")
	

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	if (dash_timer != null):
		dash_timer.queue_free()
	player.end_dash()
	
func _finish_dash() -> void:
	finished.emit(FALLING, {"canDoubleJump" : false})
