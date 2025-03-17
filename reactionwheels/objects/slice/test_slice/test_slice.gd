@tool
extends Node2D

func _ready():
	$Types.clear()
	for option in $ReferenceRect/Slice.SliceTypes:
		$Types.add_item(option)

func set_seg_type(type_index: int):
	var new_type = $Types.get_item_text(type_index)
	$ReferenceRect/Slice.slice_type = $ReferenceRect/Slice.SliceTypes[new_type]

func _on_flavor_dropdown_flavor_selected(flavor: SliceData.Flavors) -> void:
	$ReferenceRect/Slice.flavor = flavor
