#Also taken from GDQuest
class_name PlayerState extends State

const IDLE = "Idle"
const SPRINTING = "Sprinting"
const WALKING = "Walking"
const JUMPING = "Jumping"
const SLAMJUMPING = "Slamjumping"
const FALLING = "Falling"
const DASHING = "Dashing"
const WALL_SLIDING = "WallSliding"
const SLAMMING = "Slamming"
const DIALOGUE = "Dialogue"
const GRAPPLING = "Grappling"

#Gotta change once the player has a better defined type
var player : Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")

func force_state(state) -> void:
	finished.emit(state)
