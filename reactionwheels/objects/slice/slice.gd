@tool
extends Control
class_name Slice

func _set_all_values():
		if not is_node_ready():
			await ready
		$Flavor.flavor = flavor
		if color:
			self_modulate = Color("fff5d6")
			$Flavor.variant = Flavor.Variants.COLOR
		else:
			self_modulate = SliceData.FLAVOR_DICT[flavor].mod_color
			$Flavor.variant = Flavor.Variants.BLACK

@export var flavor: SliceData.Flavors = SliceData.Flavors.DEBUG:
	set(value):
		flavor = value
		_set_all_values()

@export var color: bool = false:
	set(value):
		color = value
		_set_all_values()

func move_and_update(new_flavor: SliceData.Flavors, dest: Vector2):
	var old_pos = $Flavor.position
	var color_tween = create_tween()
	color_tween.tween_property(self, "self_modulate", Color("FFF5D6"), 0.1)
	var loc_tween = create_tween()
	loc_tween.tween_property($Flavor, "position", dest, 0.25)
	await get_tree().create_timer(0.2).timeout
	var new_color_tween = create_tween()
	new_color_tween.tween_property(self, "self_modulate", SliceData.FLAVOR_DICT[new_flavor].mod_color, 0.1)
	var icon_fade_tween = create_tween()
	icon_fade_tween.tween_property($Flavor, "self_modulate", Color("FFFFFF", 0.0), 0.05)
	await get_tree().create_timer(0.05).timeout
	$Flavor.position = old_pos
	var last_fade_tween = create_tween()
	last_fade_tween.tween_property($Flavor, "self_modulate", Color("FFFFFF", 1.0), 0.05)
	await get_tree().create_timer(0.05).timeout
	
