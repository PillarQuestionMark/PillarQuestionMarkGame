class_name WaterDrop extends RigidBody3D

@onready var platform = preload("res://Scenes/islands/volcano/volcano-dungeon/sinker/moving_sinking_platform.tscn")

var platformSinkSpeed = 0.0

func _create_platform(_area : Area3D):
	var newPlatform : MovingSinkingPlatform = platform.instantiate()
	newPlatform.sinkSpeed = platformSinkSpeed
	get_parent().add_child(newPlatform)
	queue_free()
