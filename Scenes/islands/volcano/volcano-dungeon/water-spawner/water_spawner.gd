class_name WaterSpawner extends Path3D

@export var spawnRateSeconds : float = 5
@export var spawnHeight : float = 0
@export var platformSinkSpeed : float = 0
@onready var water_drop = preload("res://Scenes/islands/volcano/volcano-dungeon/water-drop/water_drop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_water_drop()
	var timer = Timer.new()
	timer.wait_time = spawnRateSeconds
	timer.timeout.connect(_spawn_water_drop)
	add_child(timer)
	timer.start()

func _spawn_water_drop():
	var w : WaterDrop = water_drop.instantiate()
	w.platformSinkSpeed = platformSinkSpeed
	add_child(w)
	w.global_position.y += spawnHeight
