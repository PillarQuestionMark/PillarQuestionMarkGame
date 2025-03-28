class_name LaserObstacle extends Node3D
## The parent class representing any of the three parts of laser puzzles (emitters, reflectors, and receivers).

@export var laser : Node3D = null
@export var laser_distance : float = 100

## Fires the given laser in the direction specified.
func fire(laser : Node3D, direction : Vector3) -> void:
	
	## THESE TWO TOGETHER IGNORES ALL ROTATION I THINK
	##direction = direction.rotated(Vector3.UP, -global_rotation.y)
	##direction = direction.rotated(Vector3.UP, -rotation.y)
	
	
	##direction = direction.rotated(Vector3.UP, -self.global_rotation.y)
	##var save_dir = direction
	##direction = direction.rotated(Vector3.UP, -rotation.y)
	## set up raycast
	var adj_dir = direction.rotated(Vector3.UP, -global_basis.get_euler().y)
	var ray : RayCast3D = RayCast3D.new()
	##ray.set_target_position(direction * laser_distance)
	ray.set_target_position(adj_dir * laser_distance)
	
	##var test = CSGSphere3D.new()
	##test.global_position = ray.target_position
	##self.add_child(test)
	
	##ray.set_collision_mask_value(1, false)
	ray.set_collision_mask_value(7, true)
	##ray.collide_with_areas = true
	self.add_child(ray)
	ray.force_raycast_update()
	
	laser.visible = true ## show the laser visual
	$Timer.start()
	
	var delta = direction * laser_distance
	##var delta = -save_dir * laser_distance ## get the distance traveled
	var hit = ray.get_collider()
	print(str(hit) + " was HIT!")
	if (hit != null):
		if (hit.has_method("laser_hit")):
			##hit.laser_hit(direction.rotated(Vector3.UP, rotation.y), ray.get_collision_normal())
			hit.laser_hit(direction, ray.get_collision_normal())
		delta = abs(ray.get_collision_point() - ray.global_position) ## update distance if cut short

	## update visible laser

	laser.height = delta.length()
	laser.position = Vector3.ZERO
	##print(str(self) + " local: " + str(laser.position) + " global: " + str(laser.global_position))
	laser.position = laser.position + (adj_dir * delta.length() / 2)
	##print(str(self) + " local: " + str(laser.position) + " global: " + str(laser.global_position))
	
	##print(str(self) + " direction: " + str(direction) + " adj_dir: " + str(adj_dir))
	##print(str(self) + " rotation: " + str(rad_to_deg(rotation.y)))
	##print(str(self) + " rotating by: " + str(rad_to_deg(rotation.angle_to(adj_dir))))
	
	laser.look_at_from_position(laser.global_position, laser.global_position + adj_dir, Vector3.UP)
	laser.rotate_y(global_rotation.y)
	laser.rotation.x = deg_to_rad(-90)
	
	##var angle = laser.basis.z.angle_to(adj_dir * delta.length())
	##print(str(self) + " angle: " + str(rad_to_deg(angle)))
	
	
	##laser.rotate_y(basis.z.angle_to(direction))
	##laser.rotate_y(-rotation.y)

	
	
	##print(str(self) + " adj_dir: " + str(adj_dir))
	
	##laser.rotation.y = 0
	##laser.rotate(Vector3.UP, Vector3.FORWARD.angle_to(adj_dir))
	
	
	
	##laser.look_at(laser.position + (adj_dir * delta.length()), Vector3.UP)
	##laser.rotate_x(deg_to_rad(-90))
	
	##laser.global_rotation.y = 0
	##laser.rotate(Vector3.UP, Vector3.FORWARD.angle_to(direction))
	
	
	##laser.global_rotation.y = 0
	##laser.rotation.y = 0
	##laser.rotate_y(Vector3.FORWARD.angle_to(direction) - rotation.y)
	##laser.rotat
	
	##laser.rotation.y = 0
	##laser.global_rotate(Vector3.UP, Vector3.FORWARD.angle_to(direction) - rotation.y)
	##laser.rotate_y(Vector3.FORWARD.angle_to(direction))
	##laser.rotate_y(rotation.y)
	
	
	##direction * laser_distance
	
	
	
	##laser.look_at(laser.global_position + (direction * delta.length()), Vector3.UP)
	##laser.rotate_x(deg_to_rad(-90))
	##laser.rotate(Vector3.UP, -rotation.y)
	##direction = direction.rotated(Vector3.UP, -rotation.y)
	
	
	##laser.global_position = laser.global_position + (save_dir * delta / 2)
	
	## get rid of raycast
	##ray.queue_free()
	
## Ends the laser display
func end_laser() -> void:
	laser.visible = false
		
## Handles the reaction to being hit with a laser.
func laser_hit(direction : Vector3, normal : Vector3) -> void:
	print("Lasrer Andy")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
