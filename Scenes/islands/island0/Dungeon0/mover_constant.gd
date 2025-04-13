extends Node3D

@export var movement := Vector3(0, 4, 0)
@export var duration := 1.0

var _initialpos := Vector3.ZERO
var _finalpos := Vector3.ZERO
var _is_targeting_initial_pos := false

func _ready() -> void:
	assert(get_parent_node_3d() != null)
	
	_initialpos = get_parent_node_3d().position
	_finalpos = _initialpos + movement

	# Start moving on ready
	_move()

func _move() -> void:
	# Set target position
	var targetpos := _finalpos if not _is_targeting_initial_pos else _initialpos
	_is_targeting_initial_pos = !_is_targeting_initial_pos
	
	# Create tween and animate movement
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(get_parent_node_3d(), "position", targetpos, duration)
	
	# When the tween finishes, call _move() again to continue the loop
	t.finished.connect(_move)
