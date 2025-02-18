extends CanvasLayer

@onready var photos: Array[TextureRect] = [
	$%Photo1,
	$%Photo2,
	$%Photo3,
	$%Photo4,
	$%Photo5,
	$%Photo6,
	$%Photo7,
]

var names := [
	"SEVEN",
	"TEDDY",
	"DAWN",
	"ALEX",
	"SAM",
	"CAROLINE",
	"LUKE",
]

@onready var nametag: Label = $%Nametag

const PHOTO_GAP := 64.0
const PHOTO_WIDTH := 256
const PHOTO_HEIGHT := 512

func _ready() -> void:
	_update_nametag_fontsize()
	
	for p in photos:
		p.animate()
	
	$AnimationPlayer.play("splash")
	
	# TODO: play some sound

var name_idx := 0.0
func _process(delta: float) -> void:
	_update_nametag_fontsize() # TODO: instead of doing this every frame, do it only when the text changes or the screen/viewport is resized
	
	# set photo size (distribute available space, and keep a 1:3 aspect ratio)
	for p in photos:
		p.size.x = get_viewport().size.x / photos.size()
		p.size.y = p.size.x * 3
	
	# arrange the photos
	for i in photos.size():
		var p := photos[i]
		p.origin.x = p.size.x * (i + 0.5)
		p.origin.y = get_viewport().size.y / 2
	
	# skip
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
		_finish()

## make nametag's font big enough to cover screen
func _update_nametag_fontsize() -> void:
	var vp_width: float = get_viewport().size.x
	# this math is approximate and will vary depending on the font used
	# at 1300pt, a single character covers an 800px wide screen
	var fontsize := ((vp_width / 800.0) * 1300.0) / nametag.text.length()
	nametag.add_theme_font_size_override("font_size", fontsize)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_finish()

func _finish() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
