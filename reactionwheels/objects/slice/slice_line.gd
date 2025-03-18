@tool
extends Label

@export var char_width: int = 4

@export var contents: Array[SliceData.Flavors] = []:
	set(value):
		contents = value
		update_text()


@export var append_plus: bool = false:
	set(value):
		append_plus = value
		update_text()

func update_text() -> void:
	var slice_text = ""
	for f in contents:
		slice_text += SliceData.FLAVOR_DICT[f].f_icon
	if append_plus:
		slice_text += "➕"
	var new_text = ""
	for i in range(len(slice_text)):
		if i % char_width == 0 and i != 0:
			new_text += "\n"
		new_text += slice_text[i]
	text = new_text
