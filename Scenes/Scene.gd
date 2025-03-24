class_name GameScene extends Node3D
## A playable scene within the game. This class handles a lot of setting up the scene.

## The island id, should be unique for each island. Each scene that is part of an island should have the same island id.
@export var island_id : int = 0 

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.info("scene: loading save data")
	_load_data()
	
	Logger.info("scene: ready")
	
	Logger.info("flames collected on current island: " + str(PlayerData.get_island_flames(island_id).size()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Takes save data and applies it to the scene.
func _load_data() -> void:
	## find the checkpoint to load the player at
	for checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == PlayerData.data["checkpoint"]:
			checkpoint.set_player($Player)
	
	## find the dungeon doors and open them if previously opened
	for door in get_tree().get_nodes_in_group("flame_door"):
		if PlayerData.data["open_dungeons"].has(float(door.island_id)): ## cast as float to avoid issues
			door.queue_free()
	
	## delete the flames that have already been collected
	for flame in get_tree().get_nodes_in_group("flames"):
		if PlayerData.get_island_flames(island_id).has(flame.id):
			flame.queue_free()
