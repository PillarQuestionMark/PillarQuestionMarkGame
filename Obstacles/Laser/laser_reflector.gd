extends LaserObstacle

func laser_hit(direction : Vector3, normal : Vector3) -> void:
	var new_dir = 2 * -direction.dot(normal) * normal + direction
	##print("old direction: " + str(direction) + " new direction: " + str(new_dir) + " normal: " + str(normal))
	##print(str(self) + " was hut!")
	
	
	##print("HIT BY: " + str(direction))
	##var new_dir = Vector3(-direction.z, 0, -direction.x)
	##laser.rotation.y = 0
	##laser.rotate(Vector3.UP, deg_to_rad(reflect_laser(direction)))
	
	##print("rotated from " + str(direction) + " by " + str(rad_to_deg(reflect_angle(direction))))
	##var new_dir = direction.rotated(Vector3.UP, reflect_angle(direction))
	
	
	##print(new_dir)
	##var angle = Vector3.FORWARD.angle_to(new_dir)
	##print(rad_to_deg(angle))
	##laser.global_rotation.y = angle
	##laser.rotate(Vector3.UP, angle)
	
	
	##print("old facing: " + str(-laser.basis.z) + " and new direction: " + str(new_dir))
	##print("rotate angle: " + str(-laser.basis.z.angle_to(new_dir)))
	##laser.rotate(Vector3.UP, -laser.basis.z.angle_to(new_dir))
	##print("new facing: " + str(-laser.basis.z))
	##if abs(new_dir.z) < 0.5 else deg_to_rad(90)
	
	##print("firing in direction: " + str(new_dir))
	##laser.rotation.x = -90
	##print("to " + str(new_dir))
	##laser.rotation.y = direction.angle_to(new_dir)
	fire(laser, new_dir)
	##fire(laser, direction)

	
func reflect_laser(dir : Vector3) -> float:
	if (dir.z != 0):
		return 90 if dir.z < 0 else 270
	else:
		return 0 if dir.x < 0 else 180
	
## Get the correct angle reflection.
## Note: DO NOT ROTATE THE REFLECTOR BY 180 DEGREES (stick to 0, 90, or -90) OTHERWISE GODOT WILL SIT THERE AND SAY
## "hmmm.. yeah no. its actually 179.99 degrees rotated"?!?!?!?! LITERALLY TROLLING.
## NUMBERS WERE NEVER MEANT TO HAVE DECIMAL PLACES.
## I DON'T NEED TO BE ROTATED 179.99 DEGREES!!!
## I WANT TO BE ROTATED 180 DEGREES
## NOBODY CARES ABOUT THAT .9 PART
## FIRST FLOATS ARE NOT INTS
## NOW YOU SIT HERE AND TELL ME THAT WHEN I SET A ROTATION TO 180 IT ISNT 180 AND I CANNOT RELY ON THAT
## IF TRUE... CAN I RELY ON ANYBODY OR ANYTHING?
## NO? OKAY.
func reflect_angle(dir : Vector3) -> float:
	var angle = -90.0
	##print("STARTING REflect")
	##print(str(dir.z) + " is the z value here?")
	if (abs(dir.z) <= 0.5):
		angle = angle * -1
		##print("dir z condition true")
	if (abs(rad_to_deg(rotation.y) as int) % 180) != 0:
		angle = angle * -1
		##print("angle 90 condition true: angle is : " + str(rad_to_deg(rotation.y) as int))
	##print(angle)
	return deg_to_rad(angle)
	

func interacted() -> void:
	print("INTERACTED")
	##rotation.y = deg_to_rad(90) if rotation.y == deg_to_rad(0) else 0
	self.rotate(Vector3.UP, deg_to_rad(90))
	print(rad_to_deg(rotation.y))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
