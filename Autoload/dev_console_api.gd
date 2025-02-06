## contains functions accessible to the "run" command in the dev console.
## it's passed as the `base_instance` for the `Expression.execute()` call.
## see `dev_console_screen.gd`.
##
## you can use `Object.set_indexed()` to assign variables.
extends Node

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")
