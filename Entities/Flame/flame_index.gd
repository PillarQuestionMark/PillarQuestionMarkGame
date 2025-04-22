class_name FlameIndex
## A utility class used to access thelist of all flames on an island with their name and id.

## Stores a list of dictionaries from each island, sorted by island id then by flame id.
const flames : Dictionary = {
	IslandData.Islands.Dev0: {
		0: "Humble Beginnings",
		8: "OUTTA TIME",
		9: "I WILL HAVE ORDER",
		10: "Spark Andy"
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
		3: "Sea Lord",
		4: "Sparks: Ruins",
		5: "Timer: Ruins",
		6: "Order: Ruins"
	},
	IslandData.Islands.Village: {},
	IslandData.Islands.Lighthouse: {
		0: "Mushrooms <3",
		1: "Rocks Can Have Secrets",
		2: "What a View!",
		3: "That doesn't look good....",
		4: "Awesome!!",
		5: "Sparks: Jungle",
		6: "Timer: Jungle",
		7: "Order: Jungle"
	},
	IslandData.Islands.Volcano: {
		0: "Crushed Hope",
		1: "Overbearing Endings",
		2: "The end...",
		3: "New Toys!",
		4: "Rock Climbing!",
		5: "Fire from sparks",
		6: "Pressure forms Diamonds",
		7: "The Rocky Ages",
		8: "You're on fire!"
	},
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
	
