extends TabContainer

func _process(_delta):
	for tab in range(0, current_tab + 1):
		current_tab = 0
		%RightPageFlipper.receive_tab(get_current_tab_control())
	current_tab = -1

func receive_tab(tab : Control):
	tab.reparent(self)
	move_child(tab, 0)
	current_tab = -1
