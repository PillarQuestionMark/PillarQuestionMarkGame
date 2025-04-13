class_name MovingLavaPlatform extends PathFollow3D

var platformSpeed : float = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	progress += platformSpeed * delta
	if progress_ratio >= 1.0 :
		queue_free()
