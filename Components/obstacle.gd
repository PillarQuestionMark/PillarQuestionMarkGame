extends Area3D

# This creates a basic collider for the obstacle if nothing is provided.
func _ready():
	pass

# Reacts to being collided by the player. 
func _on_body_entered(body : Node3D):
	if body is Player:
		body.call_deferred("die")
