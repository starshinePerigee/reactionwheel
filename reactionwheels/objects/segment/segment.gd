@tool
extends Control

@export var flavor: SliceData.Flavors = SliceData.Flavors.TEST_SLICE:
	set(value):
		flavor = value
		$SegmentFill.self_modulate = SliceData.FLAVOR_DICT[flavor].mod_color
		$SegmentIcon.text = SliceData.FLAVOR_DICT[flavor].icon
