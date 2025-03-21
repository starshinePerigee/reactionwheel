extends Node2D


func _on_flavor_dropdown_2_flavor_selected(flavor: SliceData.Flavors) -> void:
	$Action.action_post()

func _on_flavor_dropdown_3_flavor_selected(flavor: SliceData.Flavors) -> void:
	$Action.activation_flavor = flavor
	$Action.rebuild()

func _on_button_pressed() -> void:
	$Buffer2.clear_contents()

func _on_check_box_toggled(toggled_on: bool) -> void:
	$Action.automatic = toggled_on
	$Action.rebuild()

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	$Action.inputs_optional = toggled_on
	$Action.rebuild()

func _on_wait_button_pressed() -> void:
	$Action.action_pre()
	$Buffer.add_slice($FlavorDropdown.flavor)
	$Action.action_post()

func _on_force_button_pressed() -> void:
	$Action.do_activation()
