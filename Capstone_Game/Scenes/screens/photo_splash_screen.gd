extends CanvasLayer

@onready var photos: Array[Sprite2D] = [
	$%Photo1,
	$%Photo2,
	$%Photo3,
	$%Photo4,
]

var names := [
	"SEVEN",
	"KYRIE",
	"TEDDY",
	"DAWN",
	"ALEX",
	"SAM",
	"CAROLINE",
	"LUKE",
]

@onready var animator: AnimationPlayer = $%AnimationPlayer
@onready var nametag: Label = $%Nametag

const PHOTO_GAP := 64.0
const PHOTO_WIDTH := 256
const PHOTO_HEIGHT := 512

func _ready() -> void:
	_update_nametag_fontsize()
	
	animator.play("splash")
	# TODO: play some sound

var name_idx := 0.0
func _process(delta: float) -> void:
	# choose which name to display based on how far the animation has played
	var completion := animator.current_animation_position / animator.current_animation_length
	var step := floori(completion * names.size())
	step = clampi(step, 0, 7)
	nametag.text = names[step]
	
	#name_idx += delta * 52
	#nametag.text = names[floori(name_idx) % names.size()]
	
	_update_nametag_fontsize()

## make nametag's font big enough to cover screen
func _update_nametag_fontsize() -> void:
	var vp_width: float = get_viewport().size.x
	# this math is approximate and will vary depending on the font used
	# at 1300pt, a single character covers an 800px wide screen
	var fontsize := ((vp_width / 800.0) * 1300.0) / nametag.text.length()
	nametag.add_theme_font_size_override("font_size", fontsize)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Playground.tscn")
