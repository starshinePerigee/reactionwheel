extends Node2D


func _on_flavor_dropdown_2_flavor_selected(flavor: SliceData.Flavors) -> void:
	$Action.check_activation_cost()

func _on_flavor_dropdown_3_flavor_selected(flavor: SliceData.Flavors) -> void:
	$Action.activation_flavor = flavor
	print($Action.check_activation_cost())

func _on_button_pressed() -> void:
	$Buffer2.clear_contents()

func _on_check_box_toggled(toggled_on: bool) -> void:
	$Action.automatic = toggled_on

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	$Action.inputs_optional = toggled_on

func _on_wait_button_pressed() -> void:
	$Action.do_turn()
	$Buffer.add_slice($FlavorDropdown.flavor)

func _on_force_button_pressed() -> void:
	$Action.do_activation()
