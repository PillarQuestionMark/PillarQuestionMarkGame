extends Label3D

@export var action : String = "interact"

@export var base_text : String = "press {key} to interact"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_switch_control()
	EventBus.control_switch.connect(_switch_control)
	EventBus.rebind.connect(_switch_control)

func _switch_control() -> void:
	text = base_text.format({"key": Settings.get_control(action)})
