class_name Flame extends Area3D

## Flames are the main collectable in the game. This class manages the details per flame.

@export var id : float = 0 ## A unique id used to reference a specific flame.
@export var flame_name := "Humble Beginnings" ## The display name of the flame.
@export var color := Color("#e1a845") ## The color of the flame.

@onready var island : int = get_tree().current_scene.island_id ## An id used to identify which island this flame belongs to.

## Runs when a collision happens with the flame, checks if the player touched it, if so, it is picked up.
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		pickup()

## Handle the event signal and saving data portion of flames.
func pickup() -> void:
	PlayerData.flame_collected(id, island)
	EventBus.flame_found.emit(flame_name, color)
	queue_free()

## Called on loading the scene. Sets the color.
func _ready() -> void:
	flame_name = FlameIndex.get_flame_name(island, id)
	_apply_color()
	$FlameModel.color = color

## Helps to set the color of the flame.
func _apply_color() -> void:
	$OmniLight3D.light_color = color
