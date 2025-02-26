class_name CrumblingPlatformRespawnable extends Node3D

@export var crumble_time: float = 1.0
@export var respawn_time: float = 3.0

var crumble_timer: Timer
var respawn_timer: Timer
var collision_body: CollisionObject3D
var collision_shape: CSGBox3D

func _ready() -> void:
	# Find the collision body (assumes there's one in the children)
	for child in get_children():
		if child is CollisionObject3D:
			collision_body = child
		if child is CSGBox3D:
			collision_shape = child		
			break
	
	# Setup crumble timer
	crumble_timer = Timer.new()
	add_child(crumble_timer)
	crumble_timer.wait_time = crumble_time
	crumble_timer.one_shot = true
	crumble_timer.timeout.connect(_timer_end)
	
	# Setup respawn timer
	respawn_timer = Timer.new()
	add_child(respawn_timer)
	respawn_timer.wait_time = respawn_time
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_respawn_platform)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and body.is_on_floor():
		crumble_timer.start()

func _timer_end() -> void:
	visible = false
	set_process(false) 
	if collision_shape:
		collision_shape.set_collision_layer_value(3, false)
		collision_shape.set_collision_mask_value(2, false)
	respawn_timer.start()


func _respawn_platform() -> void:
	visible = true
	set_process(true)  # Re-enable processing
	if collision_shape:
		collision_shape.set_collision_layer_value(3, true)
		collision_shape.set_collision_mask_value(2, true)
