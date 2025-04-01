class_name LaserEmitter extends LaserObstacle

func interacted():
	##print("haha... there's like... a reference here... XDDD" + str(-basis.z.rotated(Vector3.UP, global_rotation.y)))
	##fire(laser, -basis.z.rotated(Vector3.UP, global_rotation.y))
	
	##print("haha... there's like... a reference here... XDDD" + str(-global_basis.z))
	fire(laser, -global_basis.z)
	##print("angles: " + str(global_basis.get_euler()))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
