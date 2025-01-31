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
@onready var wall_slide_particles: GPUParticles3D = %WallSlideParticles

@onready var interactor: Interactor = %Interactor

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(Camera != null, "The Player Node requires a Camera of type Node3D to find its bearings")
	
	EventBus.dialogue.connect(func(dialogue: Array[String]):
		$StateMachine.state.finished.emit("Dialogue")
	)
	EventBus.dialogue_finished.connect(func():
		# wait at least 1 full _process() frame to make sure the interact
		# keypress used to finish the dialogue screen doesn't immediately get
		# read by player idle state code again.
		# otherwise, dialogue interactables can get immediately interacted with
		# again, showing the entire dialogue again.
		# see also: dialogue_screen.gd
		await get_tree().process_frame
		await get_tree().process_frame
		# simply changing out of the Dialogue state after waiting is enough.
		# we don't need to stop _process() from doing anything because the
		# player can't interact while in the Dialogue state.
		$StateMachine.state.finished.emit("Idle")
	)

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

func try_interact() -> void:
	interactor.try_interact()
