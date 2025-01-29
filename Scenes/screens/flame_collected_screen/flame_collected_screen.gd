extends CanvasLayer


@export var flame_name := "Humble Beginnings"


func _ready() -> void:
	get_tree().paused = true
	%FlameName.text = flame_name


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		get_tree().paused = false
		queue_free()
