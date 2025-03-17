@tool
extends Node2D

func _ready():
	$Flavors.clear()
	for option in SliceData.Flavors:
		$Flavors.add_item(option)
	$Types.clear()
	for option in $ReferenceRect/Slice.SliceTypes:
		$Types.add_item(option)

func set_seg_type(type_index: int):
	var new_type = $Types.get_item_text(type_index)
	$ReferenceRect/Slice.slice_type = $ReferenceRect/Slice.SliceTypes[new_type]

func set_seg_flavor(flavor_index: int):
	var new_flavor = $Flavors.get_item_text(flavor_index)
	$ReferenceRect/Slice.flavor = SliceData.Flavors[new_flavor]
