extends Node2D


func _on_button_pressed() -> void:
	$Wheel.rotation_position += 1
	$Slice1.flavor = $Wheel.get_slice_from_pos(1).flavor
	$Slice2.flavor = $Wheel.get_slice_from_pos(2).flavor


func _on_load_button_pressed() -> void:
	$Wheel.get_slice_from_pos(0).flavor = $FlavorDropdown.flavor
