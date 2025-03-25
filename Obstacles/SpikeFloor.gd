@tool extends MultiMeshInstance3D

@export_range(0.1, 100) var spikeScale : float = 1.0 :
	set(value):
		spikeScale = value
		ChangedProperty.emit()
@export_range(0.1, 100) var xSize : float = 1 :
	set(value):
		xSize = value
		ChangedProperty.emit()
@export_range(0.1, 100) var zSize : float = 1 :
	set(value):
		zSize = value
		ChangedProperty.emit()
@export_enum("Rescale","Overflow") var mode : int = 0 :
	set(value):
		mode = value
		ChangedProperty.emit()

var spikeRows : int
var spikeColumns : int
var spikeScalar : Vector3
var spikeMesh = preload("res://Assets/Meshes/SpikeMesh.tres")

signal ChangedProperty

# Called when the node enters the scene tree for the first time.
func _ready():
	ChangedProperty.connect(update_properties)
	#Convert size variables to a spike count
	if mode == 0:
		#Make minimal changes to the desired scale to fit the spikes in the x and z scales
		spikeRows = maxi(1, roundi(xSize / spikeScale))
		spikeColumns = maxi(1, roundi(zSize / spikeScale))
		spikeScalar = Vector3(xSize / spikeRows, spikeScale, zSize / spikeColumns)
	else:
		#No changes to be made to scale, just create enough spikes to cover the floor
		spikeRows = ceili(xSize / spikeScale)
		spikeColumns = ceili(zSize / spikeScale)
		spikeScalar = Vector3(spikeScale, spikeScale, spikeScale)
	
	#Set up multimesh
	multimesh = MultiMesh.new()
	multimesh.mesh = spikeMesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = spikeRows * spikeColumns
	#Create and place duplicates of the spike meshes
	var index : int = 0
	for row in range(spikeRows):
		for col in range(spikeColumns):
			var spikeTransform : Transform3D = Transform3D(basis, Vector3((0.5 + row),0.0,(0.5 + col)))
			spikeTransform = spikeTransform.scaled(spikeScalar)
			multimesh.set_instance_transform(index, spikeTransform)
			index += 1
	#Set the CollisionShape3D to encompass the spikes
	var boxShapeSize : Vector3 = spikeScalar
	boxShapeSize.x *= spikeRows
	boxShapeSize.z *= spikeColumns
	var boxShape : BoxShape3D = BoxShape3D.new()
	boxShape.set_size(boxShapeSize)
	%CollisionShape3D.shape = boxShape
	#Move the collision transform to encompass the spikes
	var collisionTransform : Vector3 = spikeScalar / 2.0
	collisionTransform.x *= spikeRows
	collisionTransform.z *= spikeColumns
	%CollisionShape3D.position = collisionTransform

func update_properties():
	#Convert size variables to a spike count
	if mode == 0:
		#Make minimal changes to the desired scale to fit the spikes in the x and z scales
		spikeRows = maxi(1, roundi(xSize / spikeScale))
		spikeColumns = maxi(1, roundi(zSize / spikeScale))
		spikeScalar = Vector3(xSize / spikeRows, spikeScale, zSize / spikeColumns)
	else:
		#No changes to be made to scale, just create enough spikes to cover the floor
		spikeRows = ceili(xSize / spikeScale)
		spikeColumns = ceili(zSize / spikeScale)
		spikeScalar = Vector3(spikeScale, spikeScale, spikeScale)
	
	#Set up multimesh
	multimesh = MultiMesh.new()
	multimesh.mesh = spikeMesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = spikeRows * spikeColumns
	#Create and place duplicates of the spike meshes
	var index : int = 0
	for row in range(spikeRows):
		for col in range(spikeColumns):
			var spikeTransform : Transform3D = Transform3D(basis, Vector3((0.5 + row),0.0,(0.5 + col)))
			spikeTransform = spikeTransform.scaled(spikeScalar)
			multimesh.set_instance_transform(index, spikeTransform)
			index += 1
	#Set the CollisionShape3D to encompass the spikes
	var boxShapeSize : Vector3 = spikeScalar
	boxShapeSize.x *= spikeRows
	boxShapeSize.z *= spikeColumns
	var boxShape : BoxShape3D = BoxShape3D.new()
	boxShape.set_size(boxShapeSize)
	%CollisionShape3D.shape = boxShape
	#Move the collision transform to encompass the spikes
	var collisionTransform : Vector3 = spikeScalar / 2.0
	collisionTransform.x *= spikeRows
	collisionTransform.z *= spikeColumns
	%CollisionShape3D.position = collisionTransform
