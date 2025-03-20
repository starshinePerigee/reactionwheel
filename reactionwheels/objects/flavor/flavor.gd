@tool
extends TextureRect
class_name Flavor

enum Variants {COLOR, BLACK, LARGE}

func _get_texture() -> Resource:
	match variant:
		Variants.COLOR:
			return SliceData.FLAVOR_DICT[flavor].icon_color
		Variants.BLACK:
			return SliceData.FLAVOR_DICT[flavor].icon_black
		Variants.LARGE:
			return SliceData.FLAVOR_DICT[flavor].icon_large
	return SliceData.FLAVOR_DICT[SliceData.Flavors.DEBUG].icon_color

@export var flavor: SliceData.Flavors = SliceData.Flavors.DEBUG:
	set(value):
		flavor = value
		texture = _get_texture()
				
@export var variant: Variants:
	set(value):
		variant = value
		texture = _get_texture()
		if variant == Variants.LARGE:
			size = Vector2(32, 32)
		else:
			size = Vector2(24, 24)
		custom_minimum_size = size

func _init(
	f: SliceData.Flavors = SliceData.Flavors.DEBUG, 
	v: Variants = Variants.COLOR
):
	flavor = f
	variant = v
