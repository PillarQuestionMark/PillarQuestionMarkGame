extends Node3D

@export var trigger := ""

@export var move_degrees : float = 90
@export var duration := 1.0

var moving : bool = false


func _ready() -> void:
	EventBus.trigger.connect(func(name: String):
		if name == trigger:
			_move()
	)

func _move() -> void:
	if !moving:
		moving = true
		var target = rotation.y + deg_to_rad(move_degrees)
		var t := create_tween()
		t.tween_property(self, "rotation:y", target, duration) \
			.set_ease(Tween.EASE_IN_OUT)
		await t.finished
		moving = false

##func _ready() -> void:
##	EventBus.trigger.connect(func(name: String):
##		if name == trigger:
##			_move()
##	)

##func _move() -> void:
##	rotate(Vector3.UP, deg_to_rad(90))
