extends StaticBody3D


@export_multiline var dialogue: Array[String] = [
	"turtle: hello there!"
]

func _ready() -> void:
	$turtle/AnimationPlayer.play("Idle_A")

func _on_interactable_on_interacting() -> void:
	EventBus.dialogue.emit(dialogue)
	
	$turtle/AnimationPlayer.play("Clicked")
	await $turtle/AnimationPlayer.animation_finished
	$turtle/AnimationPlayer.play("Idle_A")
