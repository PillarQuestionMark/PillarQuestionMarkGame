extends StaticBody2D
class_name IslandIcon

@export var island := IslandData.Islands.Ruins

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
	PlayerData.call_deferred("load_island", island, 0)
