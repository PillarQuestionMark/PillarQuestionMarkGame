class_name OrderChallenge extends Node3D
## Represents a challenge where objects must be interacted with in a certain order.

@export var correct_order : Array[int] = []
var current : Array = []

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Called by the order object interacted, with its unique id in the challenge.
func new_interacted(id : int) -> void:
	current.append(id)
	if (current.size() < correct_order.size()):
		AudioManager.play_fx("Chime" + str(current.size()))
	if (current == correct_order): # correct order
		parent.enable()
		AudioManager.play_fx("CorrectChime")
	else:
		if current.size() == correct_order.size(): # incorrect order
			current.clear()
			AudioManager.play_fx("IncorrectChime")
			for pylon in get_children():
				if (pylon.has_method("off")):
					pylon.off()

## Called when the flame this order challenge belongs to was collected. (If it belongs to a flame.)
func collected() -> void:
	for pylon in get_children():
		if (pylon.has_method("turn_on")):
			pylon.turn_on()
			
