extends Area3D

@export var dungeon_path = ""

var scene_changed = false

func _ready():
	self.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		print("Entering Dungeon 1")
		call_deferred("_change_scene_and_remove_player")

func _change_scene_and_remove_player():
	if scene_changed:
		return
	scene_changed = true
	get_tree().change_scene_to_file(dungeon_path)
