class_name CrumblingWall extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		var vel : float = body.velocity.length()
		print(vel)
		var stateName : String = body.state_machine.state.name
		if stateName == PlayerState.DASHING:
			print("Hit the wall while dashing")
			queue_free()
		elif stateName == PlayerState.SLAMMING:
			print("Hit the wall while slamming")
			queue_free()
