## plays an animation when triggered
##
## NOTE: for moving platforms, walls, etc. (anything that the player needs
## to be able to stand on), `callback_mode_process` must be set to "physics",
## and the thing being moved must be an `AnimatableBody3D` with
## `sync_to_physics` off. Otherwise, it'll be a jittery mess!
extends AnimationPlayer

@export var trigger := ""
@export var animation := ""

var _is_forward := true

func _ready() -> void:
	EventBus.trigger.connect(func(name: String):
		if name == trigger:
			_on_trigger()
	)

func _on_trigger() -> void:
	# ignore if still in animation
	if is_playing():
		return
	
	if _is_forward:
		play(animation)
	else:
		play_backwards(animation)
	
	_is_forward = not _is_forward
