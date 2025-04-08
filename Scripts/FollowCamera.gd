extends SpringArm3D

#Settings.
@export_group("Settings")
#Mouse settings.
@export_subgroup("Mouse settings")
#mouse sensitivity.
var mouse_sensitivity: float = 0.05
#controller sensitivity.
var controller_sensitivity: float = 0.5
#pitch clamp settings.
@export_subgroup("Clamp settings")
#max pitch in degrees.
var max_pitch : float = 80
#min pitch in degrees.
var min_pitch : float = -80
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
	update_sensitivity()
	EventBus.sensitivity_update.connect(update_sensitivity)
	
func update_sensitivity() -> void:
	mouse_sensitivity = Settings.mouse_sensitivity
	controller_sensitivity = Settings.controller_sensitivity
	print("CONTROLLER SENSITIVITY: " + str(controller_sensitivity))
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var controller = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var input : Vector2 = controller * controller_sensitivity * sensitivity_scale
	rotation.x -= input.y
	rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	rotation.y -= input.x
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
