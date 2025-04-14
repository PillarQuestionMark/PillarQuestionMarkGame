class_name MovingSinkingPlatform extends PathFollow3D

var platformSpeed : float = 2.0
var sinkSpeed : float = 0.0 :
	set(value):
		%LavaSinker.sinkSpeed = value
		sinkSpeed = value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += platformSpeed * delta
	if progress_ratio >= 1.0 :
		queue_free()
