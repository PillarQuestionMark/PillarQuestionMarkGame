extends Node3D

@export var trigger := ""

func _ready() -> void:
	EventBus.trigger.connect(func(name: String):
		if name == trigger:
			_move()
	)

func _move() -> void:
	rotate(Vector3.UP, deg_to_rad(90))
