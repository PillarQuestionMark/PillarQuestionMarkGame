extends Node3D

@export var button_up_path: NodePath = NodePath("Geometry/Button")
@export var button_down_path: NodePath = NodePath("Geometry/Button2")
@export var move_duration: float = 5.0
@export var move_distance: float = 10.0

var _is_moving: bool = false
var _elapsed_time: float = 0.0
var _start_position: Vector3
var _end_position: Vector3

func _ready():
	var button_to_move_platform = get_node_or_null(button_up_path)
	if button_to_move_platform:
		button_to_move_platform.connect("interaction_triggered", Callable(self, "_on_interaction_triggered"))
	button_to_move_platform = get_node_or_null(button_down_path)
	if button_to_move_platform:
		button_to_move_platform.connect("interaction_triggered", Callable(self, "_on_interaction_triggered"))

func _on_interaction_triggered(node, interact_id):
	if interact_id == "move_pillar_up" and not _is_moving:
		print("Button interaction triggered: Move Up!")
		_is_moving = true
		_elapsed_time = 0.0
		_start_position = global_transform.origin
		_end_position = _start_position + Vector3(0, move_distance, 0)
	elif interact_id == "move_pillar_down" and not _is_moving:
		print("Button interaction triggered: Move Down!")
		_is_moving = true
		_elapsed_time = 0.0
		_start_position = global_transform.origin
		_end_position = _start_position + Vector3(0, -move_distance, 0)

func _process(delta: float):
	if _is_moving:
		_elapsed_time += delta
		var t = _elapsed_time / move_duration
		if t >= 1.0:
			t = 1.0
			_is_moving = false
		var eased_t = t * t * (3.0 - 2.0 * t)  # Smoothstep easing
		var new_position = _start_position.lerp(_end_position, eased_t)
		var transform = global_transform
		transform.origin = new_position
		global_transform = transform
