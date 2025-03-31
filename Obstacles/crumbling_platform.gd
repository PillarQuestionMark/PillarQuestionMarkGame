class_name CrumblingPlatform extends Node3D
## A platform that disappears a certain time after the player stands on it.

## Time for how long before the platform disappears after the player lands on it.
@export var crumble_time : float = 1.0

## Timer to keep track of crumbling time.
var crumble_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Called when the player collides with the platform, starts the timer to crumble.
func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body is Player && body.is_on_floor()):
		## adds a timer to keep track of the crumble duration
		crumble_timer = Timer.new()
		add_child(crumble_timer)
		crumble_timer.wait_time = crumble_time
		crumble_timer.one_shot = true
		crumble_timer.timeout.connect(_timer_end)
		crumble_timer.start()
			
## Called when the timer ends. Gets rid of the platform.
func _timer_end() -> void:
	queue_free()
