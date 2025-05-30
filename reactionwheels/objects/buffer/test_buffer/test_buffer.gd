extends Node2D

func _ready():
	$LineEdit.text = str($Buffer.content_size)

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Buffer.content_size = int(new_text)

func _on_buffer_slice_buffer_overflow(slice: SliceData.Flavors) -> void:
	$OverflowLabel/Flavor.flavor = slice

func _on_add_button_pressed() -> void:
	var new_flavor = $AddButton/FlavorDropdown.flavor
	$Buffer.add_slice(new_flavor)

func _on_pop_button_pressed() -> void:
	var popped = $Buffer.pop_slice(int($PopButton/LineEdit2.text))
	$PopLabel/Flavor.flavor = popped

func _on_remove_button_pressed() -> void:
	$Buffer.remove_flavor($RemoveButton/FlavorDropdown.flavor)
