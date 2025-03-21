extends Area3D

var targets : Array[GrappleablePoint] = [] 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = owner.Camera.rotation

func _on_area_entered(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.append(area)
	print("TARGETS: ", targets)

func _on_area_exited(area):
	#Toggle color/indicator for grappleable objects
	if area is not GrappleablePoint:
		return
	area.toggle()
	targets.remove_at(targets.find(area))
	print("TARGETS: ", targets)

func get_best_target() -> GrappleablePoint:
	if targets.size() == 0:
		return null
	return targets.back()
