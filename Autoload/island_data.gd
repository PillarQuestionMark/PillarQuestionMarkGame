extends Node

## islands enum.
## prefer using these over integer island ids whenever possible.
## e.g. `@export var island: IslandData.Islands = IslandData.Islands.Ruins`
enum Islands {
	Dev0, # "island0"
	Dev1, # "sea castle"
	Ruins,
	Village,
	Lighthouse,
	Volcano,
}

var _scenes: Dictionary = {
	Islands.Dev0: "res://Scenes/islands/island0/Island0.tscn",
	Islands.Dev1: "res://Scenes/Playground.tscn",
	Islands.Ruins: "res://Scenes/islands/ruins/ruins_island.tscn",
	Islands.Village: "res://Scenes/islands/island0/Island0.tscn", # TODO: update when village island is done
	Islands.Lighthouse: "res://Scenes/islands/jungle/jungle_island.tscn", # it's called jungle_island.tscn but it is the lighthouse island i promise
	Islands.Volcano: "res://Scenes/islands/island0/Island0.tscn", # TODO: update when volcano island is done
}

func get_scene_path_from_island(island: Islands) -> String:
	return _scenes[island]

func get_island_from_scene_path(island_scene_path: String) -> Islands:
	var island = Islands.find_key(island_scene_path.simplify_path())
	assert(island != null)
	return island
