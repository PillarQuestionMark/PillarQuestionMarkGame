## moves its parent between its initial position and an offset position.
##
## why do we move the parent instead of moving ourselves (and thus our
## children)? it's because AnimatableBody3D (moving platforms, etc.) will
## cause jitter when interacting with the player, unless they are moved
## directly.
extends Node3D

@export var trigger1 := ""
var trigger1_on := false
@export var trigger2 := ""
var trigger2_on := true
@export var trigger3 := ""
var trigger3_on := false
@export var trigger4 := ""
var trigger4_on := false
@export var trigger5 := ""
var trigger5_on := true
@export var trigger6 := ""
var trigger6_on := true
@export var trigger7 := ""
var trigger7_on := true
@export var trigger8 := ""
var trigger8_on := false

@export var movement := Vector3(0, 0, 0)
@export var duration := 1.0

var _initialpos := Vector3.ZERO
var _finalpos := Vector3.ZERO

func _ready() -> void:
	assert(get_parent_node_3d() != null)
	
	_initialpos = get_parent_node_3d().position
	_finalpos = _initialpos + movement
	_attempt_move()
	
	EventBus.trigger.connect(func(name: String):
		if name == trigger1:
			trigger1_on = !trigger1_on
		elif name == trigger2:
			trigger2_on = !trigger2_on
		elif name == trigger3:
			trigger3_on = !trigger3_on
		elif name == trigger4:
			trigger4_on = !trigger4_on
		elif name == trigger5:
			trigger5_on = !trigger5_on
		elif name == trigger6:
			trigger6_on = !trigger6_on
		elif name == trigger7:
			trigger7_on = !trigger7_on
		elif name == trigger8:
			trigger8_on = !trigger8_on
		else:
			return
		_attempt_move()		
	)

func _attempt_move() -> void:
	var targetpos = _initialpos
	if trigger1_on and trigger2_on and trigger3_on and trigger4_on and trigger5_on and trigger6_on and trigger7_on and trigger8_on:
		targetpos = _finalpos
		AudioManager.play_fx("CorrectChime")
		print("GATE 2 uh..")

	var t := create_tween()
	t.tween_property(get_parent_node_3d(), "position", targetpos, duration) \
		.set_ease(Tween.EASE_IN_OUT)
