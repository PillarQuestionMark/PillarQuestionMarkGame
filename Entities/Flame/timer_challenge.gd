class_name TimerChallenge extends Node3D
## Represents a challenge where a timer is tied to the challenge.

@export_range(0, 100, 0.25) var time : float = 0

@onready var parent = get_parent()

var was_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the player interacts with the timer.
func on_interacted() -> void:
	print("yae > fischl")
	if !was_collected:
		$Timer.start()
		parent.enable()
		$Label3D.visible = false
	
## Called when the flame this order challenge belongs to was collected. (If it belongs to a flame.)
func collected() -> void:
	was_collected = true
	_time_out()
	$Label3D.visible = false
	

func _time_out() -> void:
	parent.disable()
	if !was_collected:
		$Label3D.visible = true
