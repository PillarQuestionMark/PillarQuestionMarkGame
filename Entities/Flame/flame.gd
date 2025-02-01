extends Area3D

@export var id : float = 0 ## stored as a float since JSON parses as a float
@export var flame_name := "Humble Beginnings"
@export var color := Color("#e1a845")

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		pickup()

func pickup() -> void:
	PlayerData.data["collected_flames"].append(id)
	EventBus.flame_found.emit(flame_name, color)
	queue_free()

func _ready() -> void:
	_apply_color()
	$FlameModel.color = color

func _apply_color() -> void:
	$OmniLight3D.light_color = color
