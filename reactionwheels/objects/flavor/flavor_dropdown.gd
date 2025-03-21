@tool
extends Control

signal flavor_selected(flavor: SliceData.Flavors)

func verify_ready():
	if not is_node_ready():
		await ready

var flavor: SliceData.Flavors

@export var label_text: String = "Flavor: ":
	set(value):
		label_text = value
		await verify_ready()
		$HBoxContainer/Label.text = value

func _ready() -> void:
	$HBoxContainer/Flavors.clear()
	for option in SliceData.Flavors:
		$HBoxContainer/Flavors.add_item(option)

func _on_flavors_item_selected(index: int) -> void:
	var new_flavor = SliceData.Flavors[$HBoxContainer/Flavors.get_item_text(index)]
	$HBoxContainer/Flavor.flavor = new_flavor
	flavor = new_flavor
	flavor_selected.emit(new_flavor)

func get_flavor(_index: int = 0) -> SliceData.Flavors:
	return flavor
	
func set_flavor(_index: int = 0, flavor_: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	self.flavor = flavor_
