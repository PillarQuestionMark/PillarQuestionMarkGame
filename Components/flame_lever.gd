extends Node3D

@export var trigger := ""

@export var is_on := false

@export var flames_required:= 0
@export_multiline var fail_dialogue: Array[String] = [ # what you see if you don't have enough flames
	"0 flames are required to use this lever!"
]

@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var island : int = get_tree().current_scene.island

func _on_interactable_on_interacting() -> void:
	# disallow interacting too fast
	if animator.is_playing():
		return
	
	print("[%s] got interacted" % get_path())
	var flames_collected = PlayerData.get_island_flames(island).size()
	if flames_collected >= flames_required:
		if is_on:
			animator.play("flip_off")
		else:
			animator.play("flip_on")
			
		is_on = not is_on
	
		EventBus.trigger.emit(trigger)
	else:
		EventBus.dialogue.emit(fail_dialogue)
	
