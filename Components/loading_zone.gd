class_name LoadingZone extends Area3D
## Component handling the area for the player to be teleported somewhere else.

@export_file("*.tscn") var scene : String = "res://Scenes/Playground.tscn" ## The scene to teleport to.
@export var checkpoint : int = 0 ## The checkpoint to teleport to.

@export var cutscene : bool = false
@export_multiline var cutscene_text : Array[String] = []

## When the player enters, loads the given scene and checkpoint.
func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	
	Logger.info("loadingzone: player entered zone, loading scene \"%s\"" % scene)
	
	if !cutscene:
		PlayerData.call_deferred("load_scene", scene, checkpoint)
	else:
		PlayerData.call_deferred("load_cutscene", cutscene_text, scene, checkpoint)
