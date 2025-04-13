extends CanvasLayer

@export var current_island := IslandData.Islands.Ruins # where the boat should start at

@onready var _boat := %BoatIcon

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_init_boat(current_island)

func _init_boat(island: IslandData.Islands) -> void:
	# find island with corresponding id
	# and put the boat there, + a random offset
	for i: IslandIcon in get_tree().get_nodes_in_group("island_icon"):
		if i.island == island:
			_boat.global_position = i.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 32.0
			return
	assert(false, "no island icon exists for island IslandData.Islands.%d" % IslandData.Islands.keys()[island])


func _process(delta: float) -> void:
	pass
