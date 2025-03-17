extends Node2D

func _ready():
	$LineEdit.text = str($Buffer.content_size)

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Buffer.content_size = int(new_text)

func _on_buffer_slice_buffer_overflow(slice: SliceData.Flavors) -> void:
	$OverflowLabel/Slice.flavor = slice

func _on_add_button_pressed() -> void:
	var new_flavor = $AddButtonControl/FlavorDropdown/HBoxContainer/Slice.flavor
	$Buffer.add_slice(new_flavor)

func _on_pop_button_pressed() -> void:
	var popped = $Buffer.pop_slice()
	$PopLabel/Slice.flavor = popped
