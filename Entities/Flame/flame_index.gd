class_name FlameIndex
## A utility class used to access thelist of all flames on an island with their name and id.

## Stores a list of dictionaries from each island, sorted by island id then by flame id.
const flames : Dictionary = {
	IslandData.Islands.Dev0: {
		0: "Bruh",
	},
	IslandData.Islands.Dev1: {
		0: "Aqueduct",
		1: "Cubes",
		2: "Castle Walls"
	},
	IslandData.Islands.Ruins: {
		0: "Arch-eologist",
		1: "It's Beautiful Up Here",
		2: "Humble Beginnings",
		3: "Sea Lord"
	},
	IslandData.Islands.Village: {},
	IslandData.Islands.Lighthouse: {},
	IslandData.Islands.Volcano: {},
}

## Returns the name of a specific flame on a specific island.
static func get_flame_name(island : int, flame : int) -> String:
	assert(flames.has(island))
	assert(flames[island].has(flame))
	return flames[island][flame]
	
## Returns a list of all the flames by id, used for iterating through them.
static func get_flame_ids(island : int) -> Array:
	assert(flames.has(island))
	return flames[island].keys()
	
## Returns the number of flames for the given island.
static func island_total_flames(island : int) -> int:
	assert(flames.has(island))
	return flames[island].size()
	
