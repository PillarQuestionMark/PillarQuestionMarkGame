class_name Player extends CharacterBody3D

@export_range(0.0, 100.0, 0.1) var Jump_Impulse : float = 25.0
@export_range(0.0, 100.0, 0.1) var Air_Speed : float = 10.0
@export_range(0.0, 100.0, 0.1) var Walk_Speed : float = 10.0
@export_range(0.0, 100.0, 0.1) var Sprint_Speed : float = 20.0
@export_range(0.0, 1.0, 0.01) var Ground_Drag : float = 0.4
@export_range(0.0, 1.0, 0.01) var Air_Drag : float = 0.04
@export_range(-100.0, 0.0, 0.5) var Gravity : float = -50.0
@export var Camera : Node3D
var speed : float
var drag : float
var move_direction : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(Camera != null, "The Player Node requires a Camera of type Node3D to find its bearings")


func _physics_process(delta):
	#Find move Direction
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_forward", "move_backward")
	var forward  := Camera.global_basis.z
	var right = Camera.global_basis.x
	move_direction = forward * input.y + right * input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	#Move
	velocity.x = lerpf(velocity.x, move_direction.x * speed, drag)
	velocity.z = lerpf(velocity.z, move_direction.z * speed, drag)
	velocity.y += Gravity * delta
	move_and_slide()
	print(round(velocity.length()))
