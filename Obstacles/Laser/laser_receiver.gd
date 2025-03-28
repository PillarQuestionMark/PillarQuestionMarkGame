class_name LaserReceiver extends LaserObstacle

func interacted():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$CSGBox3D2.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func laser_hit(direction : Vector3, normal : Vector3) -> void:
	$CSGBox3D2.visible = true
	print(str(self) + " RECEIVER HIT!")
