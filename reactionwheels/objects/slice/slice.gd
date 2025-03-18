@tool
class_name Slice
extends Control

enum SliceTypes {ICON, BUFFBOX, SEGMENT_90, ACTION_TAIL}

const texture_buffbox = preload("res://objects/slice/buffer-box.svg")
const texture_segment_90 = preload("res://objects/slice/slice-90.svg")
const texture_action_tail = preload("res://objects/slice/action_tail.svg")

func _ready() -> void:
	$SliceIcon.label_settings = $SliceIcon.label_settings.duplicate()
	slice_type = slice_type

func verify_ready():
	if not is_node_ready():
		await ready

@export var flavor: SliceData.Flavors = SliceData.Flavors.TEST_SLICE:
	set(value):
		flavor = value
		await verify_ready()
		print("Setting slice flavor to %s" % SliceData.FLAVOR_DICT[flavor].flavor_name)
		$SliceFill.self_modulate = SliceData.FLAVOR_DICT[flavor].mod_color
		$SliceIcon.text = SliceData.FLAVOR_DICT[flavor].f_icon

func set_display_config(
	texture: Texture2D,
	texture_scale: float, 
	font_size: int,
	label_x: float,
	label_y: float, 
	label_rotation: float
):
	$SliceFill.texture = texture
	$SliceFill.scale = Vector2(texture_scale, texture_scale)
	
	$SliceIcon.label_settings.font_size = font_size
	$SliceIcon.rotation_degrees = label_rotation
	$SliceIcon.position = Vector2(label_x, label_y)
	$SliceIcon.size = Vector2(41, 45)

@export var slice_type: SliceTypes:
	set(value):
		slice_type = value
		await verify_ready()
		match slice_type:
			SliceTypes.ICON:
				set_display_config(null, 1, 24, 0, 0, 0)
			SliceTypes.BUFFBOX:
				set_display_config(texture_buffbox, 0.125, 28, 0, 2, 0)
			SliceTypes.SEGMENT_90:
				set_display_config(texture_segment_90, 0.17, 36, 5, 36, -45)
			SliceTypes.ACTION_TAIL:
				set_display_config(texture_action_tail, 0.5, 20, 9, 7, 0)

func get_flavor(index: int = 0) -> SliceData.Flavors:
	return flavor
	
func set_flavor(index: int = 0, flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	self.flavor = flavor
