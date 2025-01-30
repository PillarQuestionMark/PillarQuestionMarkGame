## area that can interact with `Interactable` nodes inside it.
##
## this is an example of designing components. it has no hard dependencies on
## anything (e.g. parent, node paths, etc.). you can put it anywhere, you can
## put more than one, it doesn't care. anyone can call `try_interact()`, and
## any `Interactable` can be interacted with.
extends Area3D
class_name Interactor

## interact with the closest `Interactable`, if there is one
func try_interact() -> void:
	# get nearby interactables
	#var interactables: Array = get_overlapping_areas().filter(func(a): a.is_in_group("interactable"))
	#interactables.append_array(get_overlapping_bodies().filter(func(b): b.is_in_group("interactable")))
	var interactables: Array[Node3D] = []
	interactables.append_array(get_overlapping_areas())
	interactables.append_array(get_overlapping_bodies())
	interactables = interactables.filter(func(i): return i is Interactable)
	print(interactables)
	
	if interactables.is_empty():
		return
	
	# get closest one
	var closest: Node3D = null
	var closest_distance := 0.0
	for i in interactables:
		var d := global_position.distance_squared_to(i.global_position)
		if closest == null or d < closest_distance:
			closest = i
			closest_distance = d
	
	print("[%s] interacting" % get_path())
	closest.interact()
