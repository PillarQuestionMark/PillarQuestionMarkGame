class_name BouncyMushroom extends Node3D

@export var bounce_height : float = 10
@export var jump_height : float = 20
@export var slam_height : float = 40
@export var slam_only : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

## Called when the player lands on the mushroom.
func _on_area_3d_body_entered(body: Node3D) -> void:
	if !(body is Player) or !body.is_on_floor(): ## avoid checks on non-players
		return
	## is check on ground needed?
	if !slam_only or _check_slam(body): ## if slam only check slam, else do nothing
		body.touched_ground() ## reset jumps (for double jumping)
		body.velocity.y += _check_height(body) ## give bounce impulse
		body.move_and_slide() ## this is needed to avoid being able to normal jump after bounce
		body.jumps_left -= 1 ## bounce counts as an initial jump
		
func _check_height(player : Player) -> float:
	var height = bounce_height ## default to normal bounce height
	if _check_slam(player):
		height = slam_height
	elif (Input.is_action_pressed("jump")):
		height = jump_height
	
	return height
	
func _check_slam(player : Player) -> bool:
	return player.state_machine.state.name == "Slamming" or player.can_slamjump()
