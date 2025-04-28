class_name GameScene extends Node3D
## A playable scene within the game. This class handles a lot of setting up the scene.

## The island id, should be unique for each island. Each scene that is part of an island should have the same island id.
@export var island := IslandData.Islands.Ruins 
@export var music : String = "Ruins"

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Logger.info("scene: loading save data")
	_load_data()
	#Dont want my ears blasted
	AudioManager.play_music(music)
	
	Logger.info("scene: ready")
	
	Logger.info("flames collected on current island: " + str(PlayerData.get_island_flames(island).size()))
	
	EventBus.request_island_id.connect(_return_id)

## Takes save data and applies it to the scene.
func _load_data() -> void:
	## find the checkpoint to load the player at
	for checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == PlayerData.data["checkpoint"]:
			checkpoint.set_player($Player)
	
	## delete the flames that have already been collected
	for flame in get_tree().get_nodes_in_group("flames"):
		if PlayerData.get_island_flames(island).has(flame.id):
			flame.queue_free()
	
	## set flame challenges as completed if the flame they hold is collected
	for challenge in get_tree().get_nodes_in_group("challenge_flame"):
		if PlayerData.get_island_flames(island).has(challenge.id):
			challenge.collected()
			
	## delete any post-dungeon objects if pre-dungeon and vice versa
	if PlayerData.data["cleared_dungeons"].has(island as int as float):
		for pre in get_tree().get_nodes_in_group("pre-dungeon"):
			pre.queue_free()
	else:
		for post in get_tree().get_nodes_in_group("post-dungeon"):
			post.queue_free()
	
func _return_id(return_function : Callable) -> void:
	return_function.call(island)
