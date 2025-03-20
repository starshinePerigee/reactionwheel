@tool
extends Node2D

func _on_flavor_dropdown_flavor_selected(flavor: SliceData.Flavors) -> void:
	for slice in $Slices.get_children():
		slice.flavor = flavor
