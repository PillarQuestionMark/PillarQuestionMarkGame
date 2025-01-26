## `Interactable` nodes can be detected and interacted with by `Interactor`
## nodes. The `on_interacting` signal is meant to be connected / listened to by
## the actual thing that's being interacted with (e.g. a button, sign, door,
## etc.).
##
## example: player -> player's Interactor -> button's Interactable -> button
##          -> EventBus.trigger("door") -> door
##
## The reason we route everything through this node, instead of directly
## to the actual thing being interacted with (e.g. button), is so that don't
## have to change a bunch of code every time we want to add a new type of
## interactable thing. It acts sorta like interfaces.
##
## If we decide that we're only gonna have a few types of interactable things,
## and don't plan on adding more, then we could get rid of this node and just
## explicitly check for each type of thing when we try to interact.
##
## example:
##     if Input.is_action_just_pressed("interact"):
##         for a in get_overlapping_areas():
##             if a is Lever: a.flip()
##             if a is Button: a.push()
##             if a is Sign: a.read()
##             ...
##
## Another option is to use groups to emulate interfaces. It's not type-safe,
## so you have to be really careful about documenting them and implementing
## everything they require.
##
## example:
##     if Input.is_action_just_pressed("interact"):
##         for a in get_overlapping_areas():
##             if a.is_in_group("interactable"):
##                 a.interact() # in this case, anything in this group MUST
##                              # implement this function
extends Area3D
class_name Interactable

signal on_interacting

func interact() -> void:
	print("[%s] on_interacting" % get_path())
	on_interacting.emit()
