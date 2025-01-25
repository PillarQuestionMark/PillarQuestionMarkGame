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
## interactable thing.
extends Area3D
class_name Interactable

signal on_interacting

func interact() -> void:
	print("[%s] on_interacting" % get_path())
	on_interacting.emit()
