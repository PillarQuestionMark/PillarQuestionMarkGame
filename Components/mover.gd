## moves its parent between its initial position and an offset position.
extends Node3D

@export var trigger := ""

@export var movement := Vector3(0, 4, 0)
@export var duration := 1.0

var _initialpos := Vector3.ZERO
var _finalpos := Vector3.ZERO
var _is_targeting_initial_pos := false

func _ready() -> void:
	assert(get_parent_node_3d() != null)
	
	_initialpos = get_parent_node_3d().position
	_finalpos = _initialpos + movement
	
	EventBus.trigger.connect(func(name: String):
		if name == trigger:
			_move()
	)

func _move() -> void:
	# each call sets targetpos and flips the target position
	var targetpos := _finalpos
	if _is_targeting_initial_pos:
		targetpos = _initialpos
	_is_targeting_initial_pos = not _is_targeting_initial_pos
	
	var t := create_tween()
	t.tween_property(get_parent_node_3d(), "position", targetpos, duration) \
		.set_ease(Tween.EASE_IN_OUT)
