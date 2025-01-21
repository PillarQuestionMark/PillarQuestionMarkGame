class_name Player extends CharacterBody3D

@export_range(0.0, 100.0, 0.1) var Jump_Impulse : float = 25.0
@export_range(0.0, 100.0, 0.1) var Air_Speed : float = 10.0
@export_range(0.0, 100.0, 0.1) var Walk_Speed : float = 10.0
@export_range(0.0, 100.0, 0.1) var Sprint_Speed : float = 20.0
@export_range(0.0, 1.0, 0.01) var Ground_Drag : float = 0.4
@export_range(0.0, 1.0, 0.01) var Air_Drag : float = 0.04
@export_range(-100.0, 0.0, 0.5) var Gravity : float = -50.0
@export_range(0.0, 100) var Rotation_Speed : float = 10.0
@export_range(0.0, 5) var Rotation_Flux : float = 2.0
@export_range(0.0, 2.0, 0.05) var Dash_Length : float = 0.1
@export_range(0.0, 100, 1) var Dash_Speed : float = 50
@export_range(0.0, 100, 1) var Slam_Gravity_Factor : float = 20
@export_range(0.0, 100, 1) var Slide_Gravity_Factor : float = 10
@export_range(0.0, 100, 1) var Wall_Kick : float = 20
@export var Camera : Node3D

var can_dash : bool = true
var dash_unlocked : bool = true

var can_wall_slide : bool = true
var wall_slide_unlocked : bool = true

var can_double_jump : bool = true
var double_jump_unlocked : bool = true

var slam_unlocked : bool = true

@onready var jump_sound: AudioStreamPlayer = %AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(Camera != null, "The Player Node requires a Camera of type Node3D to find its bearings")
	
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("menu")):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func get_move_direction() -> Vector3:
	#Determines the movement direction based on the cameras rotation
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_forward", "move_backward")
	var forward  := Camera.global_basis.z
	var right = Camera.global_basis.x
	var move_direction : Vector3 = forward * input.y + right * input.x
	move_direction.y = 0.0
	return move_direction.normalized()

func apply_speed_and_drag(speed : float, drag : float):
	var move_direction := get_move_direction()
	velocity.x = lerpf(velocity.x, move_direction.x * speed, drag)
	velocity.z = lerpf(velocity.z, move_direction.z * speed, drag)

func apply_gravity(delta : float, gravity : float = Gravity):
	velocity.y += gravity * delta
	
func get_pivot() -> Node3D:
	return $Pivot
	
func rotate_player(direction : Vector3, delta : float) -> void:
	## character faces direction you are moving (if moving)
	if (direction != Vector3.ZERO):
		## probably a better way to do this, but PIVOT (this is kind of like,,, a reference)
		var pivotChild : Node3D = get_pivot()
		var temp = Node3D.new() ## temp to use for smoothing
		temp.look_at_from_position(position, position + direction, Vector3.UP)
		## gradually rotate rather than snap to angle
		pivotChild.rotation.y = lerp_angle(pivotChild.rotation.y, temp.rotation.y, Rotation_Speed * delta)
		
## I tried to make dash cooldown handled at the dash state, but it would not work
func end_dash() -> void:
	$DashCooldown.start()
	
func restore_dash() -> void:
	print("altrive")
	can_dash = dash_unlocked
	
## Since the ground states are spread out, this code is repeated multiple times. Safer to be in one place
func touched_ground() -> void:
	can_wall_slide = wall_slide_unlocked
	can_double_jump = double_jump_unlocked
	
