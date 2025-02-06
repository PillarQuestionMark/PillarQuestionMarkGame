extends Node3D

## id should be unique within a scene
@export var id : int = 0
##@export var camera_rotation : Vector3 = Vector3.ZERO

func set_player(player : CharacterBody3D) -> void:
	player.position = position
	player.get_pivot().rotation = rotation
	##player.Camera.rotation = Vector3(deg_to_rad(camera_rotation.x), deg_to_rad(camera_rotation.y), deg_to_rad(camera_rotation.z))
	player.Camera.rotation = rotation


## called with checkpoints having an area3d
## node structure as follows:
## Checkpoint <- Area3D (link body_entered here) <- CollisionShape3D 
func _on_area_3d_body_entered(_body: Node3D) -> void:
	PlayerData.update_checkpoint(id)
	Logger.info("checkpoint: player entered checkpoint %d" % id)
