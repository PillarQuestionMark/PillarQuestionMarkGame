class_name LavaSinker extends AnimatableBody3D

@export var sinkSpeed : float = 5.0
var playerOnPlatform : bool = false
var startingHeight : float

# Called when the node enters the scene tree for the first time.
func _ready():
	startingHeight = global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerOnPlatform:
		global_position.y -= sinkSpeed * delta
	else:
		global_position.y = minf(global_position.y + sinkSpeed * delta, startingHeight)

func _on_player_standing(node : Node3D):
	playerOnPlatform = true
	print("player detected")

func _on_player_left(node : Node3D):
	playerOnPlatform = false
