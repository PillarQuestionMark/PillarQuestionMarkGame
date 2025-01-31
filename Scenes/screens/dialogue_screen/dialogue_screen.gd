## spawned in by gameplay_ui.tscn when the EventBus.dialogue signal is fired.
extends CanvasLayer
class_name DialogueScreen

## array of dialogue pages.
## prefixing a page's text with "speakernamegoeshere: " sets the speaker's name
## for that page of dialogue.
## if no speaker name is provided, the speaker for the previous page is used.
@export var dialogue: Array[String] = [
	"the voice in your head: hello?", # the speaker's name is the part before ": "
	"hi. yeah. it's me, the voice in your head.", # if no speaker, we assume it's the same one as before
	"look. whatever you're thinking, it's a [color=red][shake rate=20.0 level=5 connected=1]bad idea[/shake][/color].", # rich text labels support bbcode! see https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
	"you: ...",
]

var page_idx := 0

@onready var name_label := %Name
@onready var dialogue_label := %Dialogue
@onready var interact_label := %InteractToContinue

var tween: Tween = null

func _ready() -> void:
	name_label.text = ""
	dialogue_label.text = ""
	interact_label.text = "[f] to continue"
	
	_next_page()

func _next_page() -> void:
	if page_idx >= dialogue.size():
		_end_dialogue()
		return
	
	# extract the name and dialogue
	var data := dialogue[page_idx]
	var colon_idx := data.find(": ")
	if colon_idx != -1:
		name_label.text = data.substr(0, colon_idx)
		dialogue_label.text = data.substr(colon_idx + 2) # ": " is 2 characters
	else: # by default, keep the last speaker name
		dialogue_label.text = data
	
	page_idx += 1
	
	tween = create_tween()
	var duration: float = dialogue_label.get_total_character_count() * 0.02
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, duration) \
		.from(0.0)

func _end_dialogue() -> void:
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if dialogue_label.visible_ratio >= 1.0:
			_next_page()
		else:
			if tween != null:
				tween.kill()
			dialogue_label.visible_ratio = 1.0
