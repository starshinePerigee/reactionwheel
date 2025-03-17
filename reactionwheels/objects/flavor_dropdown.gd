@tool
extends Control

signal flavor_selected(flavor: SliceData.Flavors)
var flavor: SliceData.Flavors:
	get():
		return $HBoxContainer/Slice.flavor

func _ready() -> void:
	$HBoxContainer/Flavors.clear()
	for option in SliceData.Flavors:
		$HBoxContainer/Flavors.add_item(option)

func _on_flavors_item_selected(index: int) -> void:
	var new_flavor = SliceData.Flavors[$HBoxContainer/Flavors.get_item_text(index)]
	$HBoxContainer/Slice.flavor = new_flavor
	flavor_selected.emit(new_flavor)
