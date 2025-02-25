## moves its parent between its initial position and an offset position.
##
## why do we move the parent instead of moving ourselves (and thus our
## children)? it's because AnimatableBody3D (moving platforms, etc.) will
## cause jitter when interacting with the player, unless they are moved
## directly.
extends Node3D

@export var trigger1 := ""
@export var trigger2 := ""

@export var movement1 := Vector3(0, 0, 0)
@export var movement2 := Vector3(0, 0, 0)
@export var duration := 1.0

var _initialpos := Vector3.ZERO
var _position1 := Vector3.ZERO
var _position2 := Vector3.ZERO
var _position3 := Vector3.ZERO

var trigger1_on := false
var trigger2_on := false

func _ready() -> void:
	assert(get_parent_node_3d() != null)
	
	_initialpos = get_parent_node_3d().position
	_position1 = _initialpos + movement1
	_position2 = _initialpos + movement2
	_position3 = _initialpos + movement1 + movement2
	
	EventBus.trigger.connect(func(name: String):
		if name == trigger1:
			trigger1_on = !trigger1_on
			_move()
		elif name == trigger2:
			trigger2_on = !trigger2_on
			_move()			
	)

func _move() -> void:
	var targetpos := Vector3.ZERO
	if (trigger2_on):
		if (trigger1_on):
			targetpos = _position3
		else:
			targetpos = _position2
	elif (trigger1_on):
		targetpos = _position1

	var t := create_tween()
	t.tween_property(get_parent_node_3d(), "position", targetpos, duration) \
		.set_ease(Tween.EASE_IN_OUT)
