extends CanvasLayer


@export var flame_name := "Humble Beginnings"
@export var flame_color := Color("#e1a845")

func _ready() -> void:
	get_tree().paused = true
	AudioManager.play_fx("flame_collect")
	%FlameName.text = flame_name
	(%FlameName.label_settings as LabelSettings).font_color = flame_color
	%FlameModel.color = flame_color

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().paused = false
		queue_free()
