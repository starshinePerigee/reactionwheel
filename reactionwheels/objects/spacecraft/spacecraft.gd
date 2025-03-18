extends Node2D

func _ready():
	for child in get_children():
		if child is Action:
			child.manual_completed.connect(do_turn)

func do_turn():
	print("Doing turn")
	var all_children = get_children()
	for child in all_children:
		if child is Action:
			child.do_turn()
	for child in all_children:
		if child is Wheel:
			child.do_turn()
	for child in all_children:
		if child is Action:
			child.post_turn()
	
