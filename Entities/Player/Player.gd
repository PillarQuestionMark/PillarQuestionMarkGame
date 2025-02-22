class_name Player extends CharacterBody3D
@export_group("Movement")
@export_range(0.0, 100.0, 0.1) var Jump_Impulse : float = 25.0
@export_range(0.0, 100.0, 0.1) var Slam_Jump_Impulse : float = 40.0
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
@export_group("Camera")
@export var Transparency_Curve : Curve
@export var Camera : SpringArm3D

var can_dash : bool = true

var can_wall_slide : bool = true

var jumps_left : int = 0 # how many jumps left

var slamjump_unlocked : bool = true

@onready var jump_sound: AudioStreamPlayer = %AudioStreamPlayer
@onready var wall_slide_particles: GPUParticles3D = %WallSlideParticles
@onready var mesh : MeshInstance3D = $Pivot/MeshInstance3D

@onready var interactor: Interactor = %Interactor
@onready var slamjump_window: Timer = %SlamjumpWindow

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

func _process(delta : float) -> void:
	mesh.transparency = Transparency_Curve.sample(Camera.get_hit_length() / Camera.spring_length)
	
	## REMOVE LATER. FOR NOW, JUST TO TEST DEATH
	if Input.is_action_just_pressed("kys"):
		die()
	if Input.is_action_just_pressed("flames"):
		list_flames()
		
func list_flames() -> void:
	print("signaling glorp... flames list:")
	for island in [0, -1]:
		var collected_flames = PlayerData.get_island_flames(island)
		print("Island " + str(island) + " ... " + str(collected_flames.size()) + "/" + str(FlameIndex.island_total_flames(island)))
		for flame in FlameIndex.get_flame_ids(island):
			if (collected_flames.has(float(flame))):
				print("- " + FlameIndex.get_flame_name(island, flame))
			else:
				print("- ???")


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
	Logger.debug("player: altrive")
	can_dash = PlayerData.data["dash_unlocked"]

## Since the ground states are spread out, this code is repeated multiple times. Safer to be in one place
func touched_ground() -> void:
	can_wall_slide = PlayerData.data["wall_slide_unlocked"]
	can_dash = PlayerData.data["dash_unlocked"]
	jumps_left = PlayerData.data["max_jumps"]

func try_interact() -> void:
	interactor.try_interact()

func can_slamjump() -> bool:
	if not slamjump_unlocked:
		return false
	return not slamjump_window.is_stopped()

func start_slamjump_window() -> void:
	slamjump_window.start()

## kills the player and reloads the scene
func die() -> void:
	PlayerData.load_scene()
