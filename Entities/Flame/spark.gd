class_name Spark extends Area3D
## Sparks are collectable by the player, and spawn a flame when all are collected.

@export var id : float = 0 ## A unique id used to reference a specific flame.
@export var color := Color("#e1a845") ## The color of the spark (same as the flame is spawns).

@onready var parent_challenge : Challenge = get_parent()

## Runs when a collision happens with the flame, checks if the player touched it, if so, it is picked up.
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		pickup(body)

## Handle the event signal and saving data portion of flames.
func pickup(player : Node3D) -> void:
	var inv = player.get_inventory()
	var predicate = Callable(self, "spark_siblings")
	var sparks = inv.get_matching(predicate)
	
	if (sparks.size() == 2):
		AudioManager.play_fx("CorrectChime")
		parent_challenge.enable()
		inv.remove_all(sparks)
		for spark in sparks:
			spark.queue_free()
		queue_free()
	else:
		AudioManager.play_fx("Chime2")
		inv.call_deferred("add", self)
		collision_layer = 0
		collision_mask = 0

func spark_siblings(item : Node3D) -> bool:
	if (item is Spark):
		return item.id == id
	else:
		return false

## Called on loading the scene. Sets the color.
func _ready() -> void:
	_apply_color()
	$FlameModel.color = color

## Helps to set the color of the flame.
func _apply_color() -> void:
	$OmniLight3D.light_color = color
	
## Called if the flame it belongs to was already collected.
func collected() -> void:
	queue_free()
