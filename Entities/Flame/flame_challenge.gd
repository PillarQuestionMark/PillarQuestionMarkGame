class_name Challenge extends Node3D
## Handles details of a flame challenge.

@export var id : float = 0
@export var toggle : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.flame_found.connect(on_flame_collected)
	disable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
## Enables the node (and children).
func enable() -> void:
	toggle.visible = true
	toggle.process_mode = PROCESS_MODE_INHERIT
	set_toggle_collisions(true)
	
## Disables the node (and children).
func disable() -> void:
	toggle.visible = false
	toggle.process_mode = PROCESS_MODE_DISABLED
	set_toggle_collisions(false)
	
## Called when the player has already collected the flame represented by this challenge.
func collected() -> void:
	for child in get_children():
		if (child.has_method("collected")):
			child.collected()
		
## Triggers when a flame is collected. If the current flame, challenge is completed.
func on_flame_collected(name: String, color: Color, id : float) -> void:
	if id == self.id:
		call_deferred("collected")
		call_deferred("disable")
	
## Sets all CSG collisions in the toggle to the given value.
func set_toggle_collisions(value : bool) -> void:
	_set_collisions(toggle, value)
		
## Sets all CSG collisions to the given value, the recursive function.
func _set_collisions(node : Node, value : bool) -> void:
	if (node is CSGShape3D):
		node.use_collision = value
	for child in node.get_children():
		_set_collisions(child, value)
		
