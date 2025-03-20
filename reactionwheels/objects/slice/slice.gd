@tool
extends Control

func _set_all_values():
		if not is_node_ready():
			await ready
		$Flavor.flavor = flavor
		if colored:
			self_modulate = Color("fff5d6")
			$Flavor.variant = Flavor.Variants.COLOR
		else:
			self_modulate = SliceData.FLAVOR_DICT[flavor].mod_color
			$Flavor.variant = Flavor.Variants.BLACK

@export var flavor: SliceData.Flavors = SliceData.Flavors.DEBUG:
	set(value):
		flavor = value
		_set_all_values()

@export var colored: bool = false:
	set(value):
		colored = value
		_set_all_values()
			
