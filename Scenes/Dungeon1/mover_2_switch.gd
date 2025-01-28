## moves its parent between its initial position and an offset position.
##
## why do we move the parent instead of moving ourselves (and thus our
## children)? it's because AnimatableBody3D (moving platforms, etc.) will
## cause jitter when interacting with the player, unless they are moved
## directly.
extends Node3D

@export var trigger1 := ""
@export var trigger1_on := false
@export var trigger2 := ""
@export var trigger2_on := false

@export var movement := Vector3(0, 0, 0)
@export var duration := 1.0

var _initialpos := Vector3.ZERO
var _finalpos := Vector3.ZERO

func _ready() -> void:
	assert(get_parent_node_3d() != null)
	
	_initialpos = get_parent_node_3d().position
	_finalpos = _initialpos + movement
	_attempt_move()
	
	EventBus.trigger.connect(func(name: String):
		if name == trigger1:
			trigger1_on = !trigger1_on
		elif name == trigger2:
			trigger2_on = !trigger2_on
		_attempt_move()		
	)

func _attempt_move() -> void:
	var targetpos = _initialpos
	if trigger1_on and trigger2_on:
		targetpos = _finalpos

	var t := create_tween()
	t.tween_property(get_parent_node_3d(), "position", targetpos, duration) \
		.set_ease(Tween.EASE_IN_OUT)
