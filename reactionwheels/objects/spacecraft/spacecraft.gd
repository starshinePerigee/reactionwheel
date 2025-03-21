@tool
extends Node2D

signal turn_ended

func update_actions():
	for child in get_children():
		child.action_post()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_actions()

func _ready():
	for child in get_children():
		for c in child.get_children():
			if c is Action:
				c.manual_completed.connect(do_turn)

func do_turn():
	var all_children = get_children()
	for child in all_children:
		child.action_pre()
	for child in all_children:
		child.mid_turn()
	for child in all_children:
		child.action_post()
	turn_ended.emit()
