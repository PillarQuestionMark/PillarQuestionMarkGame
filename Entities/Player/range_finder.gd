extends Area3D

var targets : Array[GrappleablePoint] = []
var cam : SpringArm3D

func _ready():
	cam = owner.Camera

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = cam.rotation

func _on_area_entered(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.append(area)
	print("TARGETS: ")
	for target in targets:
		print(target.name)

func _on_area_exited(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.remove_at(targets.find(area))
	print("TARGETS: ")
	for target in targets:
		print(target.name)

func get_best_target() -> GrappleablePoint:
	var maxDot : float = 0.0
	var bestTarget = null
	for target : GrappleablePoint in targets:
		# Creating Variables for readability.
		var targetPos : Vector3 = target.global_position
		var camForward : Vector3 = cam.global_basis.z
		var playerPos : Vector3 = owner.global_position
		# Calculating the dot product from the forward vector of the camera
		# to the direction from player to target.
		# This dot product will be 1.0 if the player is looking directly
		# at the target.
		var dot := camForward.dot(targetPos.direction_to(playerPos))
		print(target.name, ": ", dot)
		if dot > maxDot:
			maxDot = dot
			bestTarget = target
	return bestTarget
