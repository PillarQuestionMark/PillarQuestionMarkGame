extends CanvasLayer

@export var current_island_id := 0 # where the boat should start at

@onready var _boat := %BoatIcon

@onready var _islands: Array[IslandIcon] = [
	%RuinsIsland,
	%VolcanoIsland,
	%JungleIsland
]


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_init_boat(current_island_id)

func _init_boat(island_id: int) -> void:
	# find island with corresponding id
	# and put the boat there, + a random offset
	for i in _islands:
		if i.island_id == island_id:
			_boat.global_position = i.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 32.0
			return
	assert(false, "no island icon exists with id %d" % island_id)


func _process(delta: float) -> void:
	pass
