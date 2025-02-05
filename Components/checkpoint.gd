extends Area3D
class_name Checkpoint

## id should be unique across a level
@export var id : int = 0


func set_player(player : CharacterBody3D) -> void:
	player.position = position
	player.get_pivot().rotation = rotation
	player.Camera.rotation = rotation


func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	
	Logger.info("checkpoint %d: player entered checkpoint" % id)
	PlayerData.data["checkpoint"] = id
	Logger.debug("checkpoint %d: saving player data" % id)
	PlayerData.save_data()
