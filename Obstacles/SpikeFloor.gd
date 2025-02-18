extends Node3D

@export var spikeScale : float = 1.0
@export_range(1, 100, 1) var spikeRows : int = 1
@export_range(1, 100, 1) var spikeColumns : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Prepare the spike
	var spike : MeshInstance3D = MeshInstance3D.new()
	spike.mesh = load("res://Assets/Meshes/SpikeMesh.tres")
	spike.material_override = load("res://Assets/Materials/SpikeMaterial.tres")
	spike.scale_object_local(Vector3.ONE * spikeScale)
	#Create and place duplicates of the spike meshes
	for row in range(spikeRows):
		for col in range(spikeColumns):
			var newSpike : MeshInstance3D = spike.duplicate()
			newSpike.position = spikeScale * Vector3((1 + row * 2.0),0.0,(1 + col * 2.0))
			add_child(newSpike)
	#Set the CollisionShape3D to encompass the spikes
	var boxShapeSize : Vector3 = Vector3.ONE * 2.0 * spikeScale
	boxShapeSize.x *= spikeRows
	boxShapeSize.z *= spikeColumns
	var boxShape : BoxShape3D = BoxShape3D.new()
	boxShape.set_size(boxShapeSize)
	%CollisionShape3D.shape = boxShape
	#Move the collision transform to encompass the spikes
	var collisionTransform : Vector3 = Vector3.ONE * spikeScale
	collisionTransform.x *= spikeRows
	collisionTransform.z *= spikeColumns
	%CollisionShape3D.position = collisionTransform
	
