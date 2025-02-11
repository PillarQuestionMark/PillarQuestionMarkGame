extends Node3D

@export var trigger := ""

@export var is_on := false

@export var flames_required:= 3  

@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var island : int = get_tree().current_scene.island_id

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
		var tense = "flame is" if flames_required == 1 else "flames are"
		var dialogue: Array[String] = [
		str(flames_required)+ " " + tense + " [color=red]required[/color] to open this door!",
		"keep exploring the island to find more flames!"
		]
		
		EventBus.dialogue.emit(dialogue)
	
