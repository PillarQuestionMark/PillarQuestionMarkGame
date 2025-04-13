class_name Inventory extends Node3D

## array of items in inventory
var items : Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3.UP, delta)


## Adds the given item into the player's inventory.
func add(item : Node3D) -> void:
	item.reparent(self)
	items.append(item)
	adjust_inv()
	
## Adjusts the positioning of items around the player.
func adjust_inv() -> void:
	var gap : float = deg_to_rad(360 / max(1, items.size()))
	for index in range(0, items.size()):
		var item = items[index]
		var to_rotate = Vector3(1, 0, 0)
		item.position = to_rotate.rotated(Vector3.UP, index * gap)
		
## Removes an object from the inventory
func remove(item : Node3D) -> void:
	items.erase(item)
	adjust_inv()
	
## Removes a list of objects from the inventory
func remove_all(list : Array) -> void:
	for item in list:
		items.erase(item)
	adjust_inv()
	
## Returns a list of all items in inventory matching the predicate function.
func get_matching(predicate : Callable) -> Array:
	return items.filter(predicate)
