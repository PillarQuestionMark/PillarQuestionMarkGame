extends CharacterBody2D
class_name BoatIcon


const max_speed := 150.0
const acceleration := 2000.0 # px/s^2
const deceleration := 300.0 # px/s^2

@onready var interaction_area := %InteractionArea


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		_try_interact()
	
	var direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if direction: # if there was any input
		velocity += direction.normalized() * acceleration * delta
		velocity = velocity.limit_length(max_speed)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	
	# flip boat sprite depending on direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()

func _try_interact() -> void:
	for a in interaction_area.get_overlapping_areas():
		if a is Interactable2D:
			a.interact()
