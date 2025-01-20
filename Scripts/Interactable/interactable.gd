extends Node

@export var interact_duration = 2.0
@export var interact_action = "interact"
@export var interact_id = ""
@export var max_interaction_distance = 5.0  # Maximum distance to interact

var timer = null
var is_holding = false
var interacting_node = null

@onready var player_node = get_tree().get_root().get_node("Playground/Player")  # Replace with the correct path

signal interaction_triggered(node, interact_id)

func _ready():
	timer = Timer.new()
	timer.wait_time = interact_duration
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)

func _input(event):
	if event.is_action_pressed(interact_action):
		var closest_interactable = _find_closest_interactable()
		if closest_interactable:
			is_holding = true
			interacting_node = closest_interactable
			if timer.is_stopped():
				timer.start()
	if event.is_action_released(interact_action):
		is_holding = false
		timer.stop()

func _on_timer_timeout():
	if is_holding and interacting_node == self:
		emit_signal("interaction_triggered", self, interact_id)
		timer.stop()

func _find_closest_interactable() -> Node:
	if not player_node:
		return null

	var closest_node = null
	var closest_distance = max_interaction_distance
	var player_position = player_node.global_position  # Use global_transform.origin for 3D

	for interactable in get_tree().get_nodes_in_group("interactables"):
		var interactable_position = interactable.global_position  # Use global_transform.origin for 3D
		var distance = player_position.distance_to(interactable_position)

		if distance <= closest_distance:
			closest_distance = distance
			closest_node = interactable

	return closest_node
