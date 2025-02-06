extends Node3D

## island id, should be unique for each island. each scene that is part of an island should have the same
@export var island_id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.info("scene: loading save data")
	_load_data()
	
	Logger.info("scene: ready")
	
	Logger.info("flames collected on current island: " + str(PlayerData.get_island_flames(island_id).size()))


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
		if PlayerData.get_island_flames(island_id).has(flame.id):
			flame.queue_free()
