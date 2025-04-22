extends StaticBody2D
class_name IslandIcon

@export var island := IslandData.Islands.Ruins
@export var prereqs : Array[IslandData.Islands] = []

func _ready() -> void:
	update_configuration_warnings()
	$Interact.visible = false
	if !(_check_prereqs()):
		visible = false


func _on_interactable_2d_body_entered(body: Node2D) -> void:
	if body is not BoatIcon: return
	$Interact.visible = true

func _on_interactable_2d_body_exited(body: Node2D) -> void:
	if body is not BoatIcon: return
	$Interact.visible = false


func _on_interactable_2d_on_interacting() -> void:
	if _check_prereqs():
		PlayerData.call_deferred("load_island", island, 0)
	
func _check_prereqs() -> bool:
	for prereq in prereqs:
		if !PlayerData.data["cleared_dungeons"].has(prereq as int as float):
			print("DOES NOT HAVE: " + str(prereq))
			return false
	return true
