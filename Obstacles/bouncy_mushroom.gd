class_name BouncyMushroom extends Node3D
## Bouncy Mushrooms will bounce the player who lands on them, with height depending on player movement.

@export var bounce_height : float = 10 ## Default bounce without any input.
@export var jump_height : float = 30 ## Bounce height when pressing jump.
@export var slam_height : float = 50 ## Bounce height when slamming.
@export var slam_only : bool = false ## Slam only means a mushroom will not bounce player unless they slam.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

## Called when the player lands on the mushroom.
func _on_area_3d_body_entered(body: Node3D) -> void:
	print("EEEEEE")
	if not body is Player: return
	print(body.is_on_floor())
	##if !body.is_on_floor(): return
	var player := body as Player
	
	#if player.is_on_floor(): return
	
	print(player.state_machine.state.name)
	
	## is check on ground needed?
	if player.state_machine.state.name == "Slamming" or player.can_slamjump():
		print("AAAAAA")
		print("a: %d" % player.jumps_left)
		player.touched_ground()
		player.state_machine.state.force_state("Falling")
		body.jumps_left -= 1
		print("b: %d" % player.jumps_left)
		player.velocity.y = slam_height
		#player.move_and_slide()
		#player.jumps_left += 100
		print("c: %d" % player.jumps_left)
		print(player.state_machine.state.name)
	
	elif !slam_only and Input.is_action_pressed("jump"):
		print("BBBBB")
		print("a: %d" % player.jumps_left)
		player.touched_ground()
		player.state_machine.state.force_state("Falling")
		body.jumps_left -= 1
		print("b: %d" % player.jumps_left)
		player.velocity.y = jump_height
		#player.move_and_slide()
		#player.jumps_left += 100
		print("c: %d" % player.jumps_left)
		print(player.state_machine.state.name)
	
	else:
		player.touched_ground()
		player.state_machine.state.force_state("Falling")
		body.jumps_left -= 1
		player.velocity.y = bounce_height
	
	#if !slam_only or _check_slam(body): ## if slam only check slam, else do nothing
		#body.touched_ground() ## reset jumps (for double jumping)
		#body.velocity.y += _check_height(body) ## give bounce impulse
		#body.move_and_slide() ## this is needed to avoid being able to normal jump after bounce
		#body.jumps_left -= 1 ## bounce counts as an initial jump
	
## Function used to check dynamic bounce height based on player input.
func _check_height(player : Player) -> float:
	var height = bounce_height ## default to normal bounce height
	if _check_slam(player):
		height = slam_height
	elif (Input.is_action_pressed("jump")):
		height = jump_height
	
	return height
	
## Checks whether the player is slamming.
func _check_slam(player : Player) -> bool:
	return player.state_machine.state.name == "Slamming" or player.can_slamjump()
