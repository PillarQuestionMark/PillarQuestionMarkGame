extends PanelContainer

@onready var tween := create_tween()
var is_showing := false

signal on_showing # right before the show animation
signal on_shown # right after the show animation
signal on_hiding # right before the hide animation
signal on_hidden # right after the hide animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -size.y
	_hide()
	
	tween.tween_callback(func():) # do nothing, prevent error about tween starting with no tweeners

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_dev_console"):
		if is_showing:
			_hide()
		else:
			_show()

func _show(instant := false) -> void:
	on_showing.emit()
	is_showing = true
	
	if instant:
		position.y = 0
		return
	
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:y", 0, 0.1).from(-size.y).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): on_shown.emit())

func _hide() -> void:
	on_hiding.emit()
	is_showing = false
	
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:y", -size.y, 0.1).from(0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): on_hidden.emit())
