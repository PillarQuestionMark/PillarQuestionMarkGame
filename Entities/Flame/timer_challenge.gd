class_name TimerChallenge extends Node3D
## Represents a challenge where a timer is tied to the challenge.

@export_range(0, 30, 0.25) var time : float = 0

@onready var parent = get_parent()

var was_collected = false

var time_left : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = 0.25
	time_left = time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the player interacts with the timer.
func on_interacted() -> void:
	if !was_collected:
		time_left = time
		$Timer.start()
		parent.enable()
		$Label3D.visible = false
	
## Called when the flame this order challenge belongs to was collected. (If it belongs to a flame.)
func collected() -> void:
	was_collected = true
	_time_end()
	time_left = 0
	$Label3D.visible = false
	$Timer.stop()
	

func _time_out() -> void:
	var tick = 1
	if (time_left < 4):
		tick = 0.25 if time_left < 2 else 0.5
	if (fmod(time_left, tick) == 0):
		AudioManager.play_fx("Tick")
	time_left -= 0.25
	if (time_left == 0):
		_time_end()
	else:
		$Timer.start()
	
func _time_end() -> void:
	parent.disable()
	if !was_collected:
		$Label3D.visible = true
		AudioManager.play_fx("IncorrectChime")
