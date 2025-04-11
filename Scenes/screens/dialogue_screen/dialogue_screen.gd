## spawned in by gameplay_ui.tscn when the EventBus.dialogue signal is fired.
extends CanvasLayer
class_name DialogueScreen

## array of dialogue pages.
## prefixing a page's text with "speakernamegoeshere: " sets the speaker's name
## for that page of dialogue.
## if no speaker name is provided, the speaker for the previous page is used.
@export_multiline var dialogue: Array[String] = [
	"the voice in your head: hello?", # the speaker's name is the part before ": "
	"hi. yeah. it's me, the voice in your head.", # if no speaker, we assume it's the same one as before
	"look. whatever you're thinking, it's a [color=red][shake rate=20.0 level=5 connected=1]bad idea[/shake][/color].", # rich text labels support bbcode! see https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html
	"you: ...",
]

var page_idx := 0

@onready var name_label := %Name
@onready var hseparator := %HSeparator
@onready var dialogue_label := %Dialogue
@onready var interact_label := %InteractToContinue

var tween: Tween = null

var _is_ready := false

var play_sfx : bool = false

func _ready() -> void:
	name_label.text = ""
	dialogue_label.text = ""
	interact_label.text = "[f] to continue"
	
	# only show the name if the dialogue explicitly sets a speaker name.
	name_label.visible = false
	hseparator.visible = false
	
	# wait at least 1 full _process() frame to make sure the interact
	# keypress used to start the dialogue screen doesn't immediately get
	# read by the dialogue screen itself.
	# otherwise, the first page of dialogue can be immediately skipped.
	# see also: Player.gd
	await get_tree().process_frame
	await get_tree().process_frame
	_is_ready = true
	
	if dialogue.size() == 0:
		_end_dialogue()
		return
	
	_show_page(0)

func _show_page(idx: int) -> void:
	
	# extract the name and dialogue
	var data := dialogue[idx]
	var colon_idx := data.find(": ")
	if colon_idx != -1:
		name_label.text = data.substr(0, colon_idx)
		dialogue_label.text = data.substr(colon_idx + 2) # ": " is 2 characters
		
		# only show the name if the dialogue explicitly sets a speaker name.
		name_label.visible = true
		hseparator.visible = true
	else: # by default, keep the last speaker name
		dialogue_label.text = data
	
	play_sfx = true
	tween = create_tween()
	var duration: float = dialogue_label.get_total_character_count() * 0.02
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, duration) \
		.from(0.0)
	await tween.finished
	play_sfx = false

func _end_dialogue() -> void:
	EventBus.dialogue_finished.emit()
	queue_free()

func _process(delta: float) -> void:
	if (play_sfx):
		AudioManager.play_fx("DialogueSFX")
	
	if not _is_ready:
		return
	
	# show the whole page, or go to next page if the whole page is already
	# visible
	if Input.is_action_just_pressed("interact"):
		if dialogue_label.visible_ratio >= 0.99:
			page_idx += 1
			if page_idx >= dialogue.size():
				_end_dialogue()
				return
			_show_page(page_idx)
		else:
			if tween != null:
				tween.kill()
				play_sfx = false
			dialogue_label.visible_ratio = 1.0
