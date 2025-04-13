class_name WaterDrop extends RigidBody3D

@onready var platform = preload("res://Scenes/islands/volcano/volcano-dungeon/sinker/moving_lava_platform.tscn")

func _create_platform(_area : Area3D):
	var newPlatform : MovingLavaPlatform = platform.instantiate()
	get_parent().add_child(newPlatform)
	queue_free()
