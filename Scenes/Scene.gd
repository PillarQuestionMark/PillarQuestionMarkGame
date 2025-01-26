extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## loads the player position from the save data dictionary
	
	var position_array = PlayerData.data["player_position"]
	$Player.position = Vector3(position_array[0], position_array[1], position_array[2])
	
	var rotation_array = PlayerData.data["player_rotation"]
	$Player.get_pivot().rotation = Vector3(rotation_array[0], rotation_array[1], rotation_array[2])
	
	var camera_array = PlayerData.data["camera_rotation"]
	$Player.Camera.rotation =  Vector3(camera_array[0], camera_array[1], camera_array[2])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
