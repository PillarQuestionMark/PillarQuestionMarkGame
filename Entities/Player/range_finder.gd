extends Area3D

var targets : Array[GrappleablePoint] = []
var cam : SpringArm3D

func _ready():
	cam = owner.Camera

func _on_area_entered(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.append(area)

func _on_area_exited(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.remove_at(targets.find(area))

func get_best_target() -> GrappleablePoint:
	var maxDot : float = 0.9
	var bestTarget = null
	for target : GrappleablePoint in targets:
		# Creating Variables for readability.
		var targetPos : Vector3 = target.global_position
		var camForward : Vector3 = -cam.global_basis.z
		var camPos : Vector3 = cam.global_position
		var targetDirection = camPos.direction_to(targetPos)
		# Create a raycast to check if the pathway is clear
		# to the grappling point
		var ray : RayCast3D = RayCast3D.new()
		ray.target_position = targetPos - camPos
		add_child(ray)
		ray.force_raycast_update()
		remove_child(ray)
		# Checks if clear before continuing
		if (!ray.is_colliding()):
		# Calculating the dot product from the forward vector of the camera
		# to the direction from player to target.
		# This dot product will be 1.0 if the player is looking directly
		# at the target.
			var dot := camForward.dot(targetDirection)
			if dot > maxDot:
				maxDot = dot
				bestTarget = target
	return bestTarget
