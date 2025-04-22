@tool
extends Area3D
class_name Checkpoint

## id should be unique across a level
@export var id : int = 0:
	set(value):
		id = value
		update_configuration_warnings()


func set_player(player : CharacterBody3D) -> void:
	player.global_position = global_position
	player.get_pivot().global_rotation = global_rotation
	player.Camera.global_rotation = global_rotation


func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	
	Logger.info("checkpoint %d: player entered checkpoint" % id)
	PlayerData.update_checkpoint(id)
	Logger.debug("checkpoint %d: saving player data" % id)
	PlayerData.save_data()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	
	for c in get_tree().get_nodes_in_group("checkpoint"):
		var c_id := (c as Checkpoint).id
		if c_id == id and c != self:
			warnings.append("Duplicate checkpoint id with checkpoint \"%s\". Checkpoint id must be unique across the current scene." % c.name)
	
	return warnings
