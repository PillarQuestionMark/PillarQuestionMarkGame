class_name LavaRiser extends AnimatableBody3D

@export var fullLoopTime : float = 10.0 ## The time, in seconds, that the full loop takes to complete.
@export var maxHeight : float = 10.0
@export var heightCurve : Curve = preload("res://Scenes/islands/volcano/volcano-dungeon/riser/default_riser_curve.tres")

var _elapsedTime : float = 0.0
var _startingHeight : float = 0.0
var _lavaColumnMesh : CylinderMesh = preload("res://Scenes/islands/volcano/volcano-dungeon/riser/lava_riser_column.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(heightCurve != null, "Lava Riser must have a curve")
	heightCurve.bake()
	_startingHeight = global_position.y
	# Calculating how long the lava column needs to be
	var columnHeight : float = maxHeight + _startingHeight + 10.0
	var lavaColumn = MeshInstance3D.new()
	lavaColumn.mesh = _lavaColumnMesh.duplicate()
	lavaColumn.mesh.height = columnHeight
	lavaColumn.position.y -= columnHeight / 2
	add_child(lavaColumn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_elapsedTime = fmod(_elapsedTime + delta, fullLoopTime)
	var newHeight = heightCurve.sample(_elapsedTime / fullLoopTime)
	global_position.y = _startingHeight + newHeight * maxHeight
