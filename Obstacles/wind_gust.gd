class_name WindGust extends Node3D
## Wind Gust to push the player in the direction it faces.

@export var gust_strength : float = 0.25

var pushing_list : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	for body in pushing_list:
		body.velocity += basis.z * gust_strength



func _on_area_3d_body_entered(body: Node3D) -> void:
	if !(body is Player):
		return
	pushing_list.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !(body is Player):
		return
	pushing_list.erase(body)
