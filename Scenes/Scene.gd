extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.info("playground: loading save data")
	_load_data()
	
	Logger.info("playground: ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## loads the player information from the save data dictionary
func _load_data() -> void:
	## find the checkpoint to load the player at
	for checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == PlayerData.data["checkpoint"]:
			checkpoint.set_player($Player)
			
	## delete the flames that have already been collected
	for flame in get_tree().get_nodes_in_group("flames"):
		if PlayerData.data["collected_flames"].has(flame.id):
			flame.queue_free()
