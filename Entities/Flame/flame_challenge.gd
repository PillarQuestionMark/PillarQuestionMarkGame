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
	
## Disables the node (and children).
func disable() -> void:
	toggle.visible = false
	toggle.process_mode = PROCESS_MODE_DISABLED
	
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
