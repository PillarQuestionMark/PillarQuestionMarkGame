@tool
extends StaticBody2D
class_name IslandIcon

@export var island_id := -999 # some dummy id that no island actually uses
@export_file("*.tscn") var island_scene: String = "":
	set(value):
		island_scene = value
		update_configuration_warnings()

func _ready() -> void:
	update_configuration_warnings()
	$Interact.visible = false


func _on_interactable_2d_body_entered(body: Node2D) -> void:
	if body is not BoatIcon: return
	$Interact.visible = true

func _on_interactable_2d_body_exited(body: Node2D) -> void:
	if body is not BoatIcon: return
	$Interact.visible = false


func _on_interactable_2d_on_interacting() -> void:
	PlayerData.call_deferred("load_scene", island_scene, 0)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if island_scene.is_empty():
		warnings.append("Island scene is empty.")
	return warnings
