@tool
class_name Segment
extends Control

enum SegmentTypes {ICON, BUFFBOX, SEGMENT_90}

const texture_buffbox = preload("res://objects/segment/buffer-box.svg")
const texture_segment_90 = preload("res://objects/segment/segment-90.svg")

func verify_ready():
	if not is_node_ready():
		await ready

@export var slice: SliceData.Slices = SliceData.Slices.TEST_SLICE:
	set(value):
		slice = value
		await verify_ready()
		print("Setting slice flavor to %s" % SliceData.FLAVOR_DICT[slice].slice_name)
		$SegmentFill.self_modulate = SliceData.FLAVOR_DICT[slice].mod_color
		$SegmentIcon.text = SliceData.FLAVOR_DICT[slice].s_icon

func set_display_config(
	texture: Texture2D,
	texture_scale: float, 
	font_size: int,
	label_x: float,
	label_y: float, 
	label_rotation: float
):
	$SegmentFill.texture = texture
	$SegmentFill.scale = Vector2(texture_scale, texture_scale)
	
	$SegmentIcon.label_settings.font_size = font_size
	$SegmentIcon.rotation_degrees = label_rotation
	$SegmentIcon.position = Vector2(label_x, label_y)
	$SegmentIcon.size = Vector2(41, 45)

@export var segment_type: SegmentTypes:
	set(value):
		segment_type = value
		await verify_ready()
		match segment_type:
			SegmentTypes.ICON:
				set_display_config(null, 1, 24, 0, 0, 0)
			SegmentTypes.BUFFBOX:
				set_display_config(texture_buffbox, 0.125, 24, 0, 2, 0)
			SegmentTypes.SEGMENT_90:
				set_display_config(texture_segment_90, 0.17, 32, 5, 36, -45)
