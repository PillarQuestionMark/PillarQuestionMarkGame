extends Node3D

@export var radius := 0.5

@onready var ray: RayCast3D = $RayCast3D
@onready var shadow: Sprite3D = $Sprite3D

func _process(delta: float) -> void:
	if ray.is_colliding():
		var ground_position := ray.get_collision_point()
		var normal := ray.get_collision_normal()
		
		# put shadow just above the ground to avoid clipping
		shadow.global_position = ground_position + (normal * 0.01)
		
		# orient shadow according to normal
		shadow.global_basis.y = normal
		shadow.global_basis.x = Vector3.FORWARD.cross(shadow.global_basis.y)
		shadow.global_basis.z = shadow.global_basis.x.cross(shadow.global_basis.y)
		
		# shadow basis was recalculated, so its scale has been reset to (1,1,1)
		shadow.scale.x = radius * 2
		shadow.scale.z = radius * 2
