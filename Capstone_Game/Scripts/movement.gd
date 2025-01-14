extends CharacterBody3D

@export_group("Movement Variables")
@export_range(-100.0, 0.0, 0.5) var gravity : float = -50.0
@export_range(0.01, 1.0, 0.01) var deceleration : float = 0.2
@export_range(0.5, 100.0, 0.5) var speed : float = 20.0
@export_range(0.0, 50.0, 0.5) var jumpStrength : float = 15.0
@export_group("Camera")
@export var camera : Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Movement
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	var forward  := camera.global_basis.z
	var right = camera.global_basis.x
	var move_direction : Vector3 = forward * input.z + right * input.x
	move_direction.y = 0.0
	move_direction.normalized()
	#Gravity
	if is_on_floor():
		velocity.y = Input.get_action_strength("jump") * jumpStrength
	#Bringing it together
	velocity.x = lerp(velocity.x, move_direction.x * speed, deceleration)
	velocity.z = lerp(velocity.z, move_direction.z * speed, deceleration)
	velocity.y += gravity * delta
	move_and_slide()
