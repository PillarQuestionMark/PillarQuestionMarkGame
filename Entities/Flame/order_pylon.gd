class_name OrderPylon extends Node3D
## An object that must be interacted in the correct order with other instances.

@export var id : int = 0
var on : bool = false
@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CSGSphere3D.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called when the player interacts with the pylon.
func on_interacted() -> void:
	var was_on = on
	turn_on()
	if !was_on:
		parent.new_interacted(id)

## Turns the pylon off.
func off() -> void:
	on = false
	$CSGSphere3D.visible = false
	$Label3D.visible = true
	
## Turns the pylon on.
func turn_on() -> void:
	on = true
	$CSGSphere3D.visible = true
	$Label3D.visible = false
