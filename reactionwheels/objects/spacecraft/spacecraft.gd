extends Node2D

func _ready():
	for child in get_children():
		for c in child.get_children():
			if c is Action:
				c.manual_completed.connect(do_turn)
	for child in get_children():
		for c in child.get_children():
			if c is Action:
				c.post_turn()

func do_turn():
	print("Doing turn")
	var all_children = get_children()
	for child in all_children:
		for c in child.get_children():
			if c is Action:
				c.do_turn()
	for child in all_children:
		if child is Wheel:
			var c = child.get_child(4)
			if not c is WheelCore:
				print("SOMETHING IS NOT WHEEL??!!?")
				continue
			c.do_turn()
	for child in all_children:
		for c in child.get_children():
			if c is Action:
				c.post_turn()
	
