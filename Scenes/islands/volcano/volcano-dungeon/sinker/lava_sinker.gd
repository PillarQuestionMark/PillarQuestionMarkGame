class_name LavaSinker extends AnimatableBody3D

@export var sinkSpeed : float = 2.0 
var startingHeight : float
var dropping : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	startingHeight = global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (dropping):
		move_and_collide(Vector3.DOWN * (sinkSpeed * delta))
	else:
		if (global_position.y < startingHeight):
			move_and_collide(Vector3.UP * sinkSpeed * delta)
	

func _on_player_standing(node : Node3D):
	dropping = true

func _on_player_left(node : Node3D):
	dropping = false
