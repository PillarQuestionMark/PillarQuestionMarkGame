extends SpringArm3D

#Settings.
@export_group("Settings")
#Mouse settings.
@export_subgroup("Mouse settings")
#mouse sensitivity.
@export_range(0.0, 1.0, 0.01) var mouse_sensitivity: float = 0.01
#pitch clamp settings.
@export_subgroup("Clamp settings")
#max pitch in degrees.
@export var max_pitch : float = 60
#min pitch in degrees.
@export var min_pitch : float = -60
#Camera settings.
@export_subgroup("Camera settings")
#Camera distance.
@export var camera_distance : float = 8.0


enum States {THIRD_BACK, THIRD_FRONT, FIRST}

var state : States = States.THIRD_BACK

const sensitivity_scale : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_length = camera_distance
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This should be moved to UI probably
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("switch_camera"):
		if state == States.THIRD_BACK:
			spring_length = 0.0
			state = States.FIRST
		elif state == States.FIRST:
			spring_length = camera_distance
			state = States.THIRD_BACK

func _unhandled_input(event):
	#Actual Camera controls
	if (not event is InputEventMouseMotion):
		return
	var input : Vector2 = event.relative * mouse_sensitivity * sensitivity_scale
	rotation.x -= input.y
	rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	rotation.y -= input.x
	
