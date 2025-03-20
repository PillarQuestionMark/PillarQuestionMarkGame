extends Area3D

# Reacts to being collided by the player. 
func _on_body_entered(body : Node3D):
	if body is Player:
		body.call_deferred("die")
