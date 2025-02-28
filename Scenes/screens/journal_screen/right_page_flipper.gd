extends TabContainer

func _process(_delta):
	for tab in range(current_tab, get_child_count() - 1):
		current_tab = get_child_count() - 1
		%LeftPageFlipper.receive_tab(get_current_tab_control())

func receive_tab(tab : Control):
	tab.reparent(self)
	set_current_tab(current_tab + 1)
