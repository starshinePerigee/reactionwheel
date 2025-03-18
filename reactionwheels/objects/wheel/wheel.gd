@tool
extends VBoxContainer
class_name Wheel

func verify_ready():
	if not is_node_ready():
		await ready

@export var input_buffer: Buffer

var WHEEL_SIZE = 4
@onready var slices = [
	$Core/Rotator/Slice0,
	$Core/Rotator/Slice1,
	$Core/Rotator/Slice2,
	$Core/Rotator/Slice3
]

#region UI handling
func pos_to_rot(pos: int) -> float:
	return fmod((360.0 / WHEEL_SIZE * pos), 360.0)
	
func rot_to_pos(rot: float) -> int:
	return int(rot / (360.0 / WHEEL_SIZE)) % WHEEL_SIZE

@export var rotation_position: int = 0:
	set(value):
		rotation_position = value % 4
		await verify_ready()
		$Core/Rotator.rotation_degrees = pos_to_rot(rotation_position)
#endregion

func get_slice_from_pos(pos: int) -> Slice:
	return slices[(pos - rotation_position) % 4]

func get_flavor(index: int = 0) -> SliceData.Flavors:
	return get_slice_from_pos(index).flavor
	
func set_flavor(index: int = 0, flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	get_slice_from_pos(index).flavor = flavor

func do_turn():
	rotation_position += 1
	var active_slice = get_slice_from_pos(0)
	if active_slice.flavor == SliceData.Flavors.NO_SLICE and input_buffer:
		active_slice.flavor = input_buffer.pop_slice()
