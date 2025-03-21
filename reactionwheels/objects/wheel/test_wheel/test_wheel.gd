extends Node2D


func _on_button_pressed() -> void:
	await $WheelCore.mid_turn()
	$Flavor.flavor = $WheelCore.get_flavor(1)
	$Flavor2.flavor = $WheelCore.get_flavor(2)
	
func _on_load_button_pressed() -> void:
	$Buffer.add_slice($FlavorDropdown.flavor)
	
