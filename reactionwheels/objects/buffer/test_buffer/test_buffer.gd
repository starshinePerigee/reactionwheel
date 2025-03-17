extends Node2D

func _ready():
	$AddButton/Flavors.clear()
	for option in SliceData.Flavors:
		$AddButton/Flavors.add_item(option)
	$LineEdit.text = str($Buffer.content_size)

func _on_line_edit_text_submitted(new_text: String) -> void:
	$Buffer.content_size = int(new_text)

func _on_buffer_slice_buffer_overflow(slice: SliceData.Flavors) -> void:
	$OverflowLabel/Slice.flavor = slice

func _on_flavors_item_selected(index: int) -> void:
	var new_flavor = $AddButton/Flavors.get_item_text(index)
	$AddButton/Slice.flavor = SliceData.Flavors[new_flavor]

func _on_add_button_pressed() -> void:
	var new_flavor = $AddButton/Slice.flavor
	$Buffer.add_slice(new_flavor)

func _on_pop_button_pressed() -> void:
	var popped = $Buffer.pop_slice()
	$PopLabel/Slice.flavor = popped
