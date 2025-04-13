extends Node3D

@export var switch_path: NodePath = NodePath("Geometry/Button")
@export var move_duration: float = 5.0
@export var move_distance: float = 10.0

var _is_moving: bool = false
var _elapsed_time: float = 0.0
var _start_position: Vector3
var _end_position: Vector3
var _in_init_position: bool = true

func _ready():
	var switch = get_node_or_null(switch_path)
	if switch:
		switch.connect("interaction_triggered", Callable(self, "_on_interaction_triggered"))
	
func _on_interaction_triggered(_node, interact_id):
	if interact_id == "toggle_gates" and not _is_moving:
		if _in_init_position:
			_is_moving = true
			_elapsed_time = 0.0
			_start_position = global_transform.origin
			_end_position = _start_position + Vector3(0, move_distance, 0)
			_in_init_position = false
		else:
			_is_moving = true
			_elapsed_time = 0.0
			_start_position = global_transform.origin
			_end_position = _start_position + Vector3(0, -move_distance, 0)
			_in_init_position = true

func _process(delta: float):
	if _is_moving:
		_elapsed_time += delta
		var t = _elapsed_time / move_duration
		if t >= 1.0:
			t = 1.0
			_is_moving = false
		var eased_t = t * t * (3.0 - 2.0 * t)
		var new_position = _start_position.lerp(_end_position, eased_t)
		var transform = global_transform
		transform.origin = new_position
		global_transform = transform
