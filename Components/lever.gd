extends Node3D

@export var trigger := ""

@export var is_on := false

@onready var animator: AnimationPlayer = %AnimationPlayer

func _on_interactable_on_interacting() -> void:
	# disallow interacting too fast
	if animator.is_playing():
		return
	
	print("[%s] got interacted" % get_path())
	
	if is_on:
		animator.play("flip_off")
	else:
		animator.play("flip_on")
	
	is_on = not is_on
	
	EventBus.trigger.emit(trigger)
	AudioManager.play_fx("lever")
