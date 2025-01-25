extends Node

@export var interact_duration = 2.0
@export var interact_action = "interact"
@export var interact_id = ""
@export var max_interaction_distance = 5.0
@export var display_bar = false
@export var node_path = ""

var timer = null
var is_holding = false
var interacting_node = null

@onready var player_node = get_tree().get_root().get_node(node_path)
@export var progress_bar_scene: PackedScene = preload("res://Scripts/Interactable/interactable_bar.tscn")
var progress_bar: Node3D = null

signal interaction_triggered(node, interact_id)

func _ready():
	if progress_bar_scene:
		progress_bar = progress_bar_scene.instantiate()
		add_child(progress_bar)
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

func _process(delta):
	var closest_interactable = _find_closest_interactable()
	if not closest_interactable:
		progress_bar.set("visible", false)
		return	
	if display_bar:
		progress_bar.set("visible", true)
	var background = progress_bar.get_node("Background") as MeshInstance3D
	var foregroundf = progress_bar.get_node("ForegroundFront") as MeshInstance3D
	var foregroundb = progress_bar.get_node("ForegroundBack") as MeshInstance3D
	background.scale.x = 1.0
	if is_holding and timer:
		var progress_ratio = (interact_duration - timer.get_time_left()) / interact_duration
		foregroundf.scale.x = progress_ratio
		foregroundb.scale.x = progress_ratio
	else:
		foregroundf.scale.x = 0
		foregroundb.scale.x = 0
	progress_bar.global_transform = closest_interactable.global_transform.translated(Vector3(0, 1, 0))
	var direction_to_player = player_node.global_position - progress_bar.global_position
	var angle = direction_to_player.angle_to(Vector3.FORWARD)
	var current_rotation = progress_bar.rotation_degrees
	current_rotation.y = angle * (180 / PI)
	progress_bar.rotation_degrees = current_rotation

func _find_closest_interactable() -> Node:
	if not player_node:
		return null
	var closest_node = null
	var closest_distance = max_interaction_distance
	var player_position = player_node.global_position
	for interactable in get_tree().get_nodes_in_group("interactables"):
		var interactable_position = interactable.global_position
		var distance = player_position.distance_to(interactable_position)
		if distance <= closest_distance:
			closest_distance = distance
			closest_node = interactable
	return closest_node
