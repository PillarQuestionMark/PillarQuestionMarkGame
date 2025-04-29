extends CanvasLayer
## A class that handles the "cutscenes".

# Classic HSR black-screen white-text cutscenes.
# All we have time for now.

## The text for the cutscene.
@export var text : Array[String] = [
	"Our story begins along the seven seas.",
	"A young adventurer, Feo, rides along with the breeze.",
	"All is well. Until...",
	"A storm comes across the deep blue, in utter surprise.",
	"Harsh lightning, oppressive thunder abounds.",
	"Feo cannot last against the tempest forever.",
	"Some day, everything will be alright. \n But today is not that day...",
	"Lightning strikes, causing Feo to splash into the crashing waves.",
	"...",
	"Feo...?", 
	"Feo...!", 
	"FEO... WAKE UP!",
	"...",
	"Nobody said that.",
	"Feo awakens alone on a strange shore."
	] # defaults to intro cutscene

## The scene to move to after the cutscene is done.
@export var next_scene : String = "res://Scenes/islands/ruins/ruins_island.tscn"

## The checkpoint to load into in the next scene.
@export var next_checkpoint : int = 0

@export var return_to_menu : bool = false

## The label to update text on.
@onready var text_container = $PanelContainer/CenterContainer/RichTextLabel

## The index in the text array
var current_text : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_container.text = "[center]" + text[0] + "[/center]"
	get_node("Button").grab_focus()
	if (Settings.control_scheme == Settings.Profile.KEYBOARD_AND_MOUSE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		_on_continue()
	
func setup(scene_text : Array[String], scene : String, checkpoint : int = 0, end_scene : bool = false) -> void:
	text = scene_text
	if text.size() > 0:
		text_container.text = "[center]" + text[0] + "[/center]"
	next_scene = scene
	next_checkpoint = checkpoint
	return_to_menu = end_scene

func _on_continue() -> void:
	current_text += 1
	if text.size() > current_text:
		text_container.text = "[center]" + text[current_text] + "[/center]"
	else:
		if (return_to_menu):
			PlayerData.data["current_scene"] = next_scene
			PlayerData.data["checkpoint"] = next_checkpoint
			PlayerData.save_data()
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		else:
			PlayerData.load_scene(next_scene, next_checkpoint)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
