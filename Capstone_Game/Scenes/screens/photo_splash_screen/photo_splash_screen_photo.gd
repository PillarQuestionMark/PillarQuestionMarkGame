extends TextureRect

@export_enum("slide_from_above", "slide_from_below") var animation: String = "slide_from_above"

@export var origin := Vector2.ZERO # where i'm centered around (use this instead of position)
@export var offset_y := 0.0 # animate me to change my y position relative to my origin

func animate() -> void:
	$AnimationPlayer.play(animation)

func _process(delta: float) -> void:
	position = origin - size/2 # center around origin
	position.y += offset_y
