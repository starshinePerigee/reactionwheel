@tool
extends Control
class_name WheelCore

func verify_ready():
	if not is_node_ready():
		await ready

func rebuild():
	await verify_ready()
	rotation_position = 0
	$RotatorFrame.rotation_degrees = 0.0
	build_start()
	update_slices()

func build_start():
	_contents = []
	for i in WHEEL_SIZE:
		if starting_contents and i < len(starting_contents):
			_contents.append(starting_contents[i])
		else:
			_contents.append(SliceData.Flavors.NO_SLICE)

func update_slices():
	for i in WHEEL_SIZE:
		if i < len(_contents):
			slices[i].flavor = _contents[i]
		else:
			slices[i].flavor = SliceData.Flavors.NO_SLICE

func _ready():
	rebuild()

@export var display_name: String:
	set(value):
		display_name = value
		await verify_ready()
		$VBoxContainer/PanelContainer/NameLabel.text = display_name

@export var input_buffers: Array[Buffer]

var _contents: Array[SliceData.Flavors]

@export var starting_contents: Array[SliceData.Flavors]:
	set(value):
		starting_contents = value
		rebuild()
	
var WHEEL_SIZE = 4
@onready var slices = [
	$RotatorFrame/Slice90,
	$RotatorFrame/Slice91,
	$RotatorFrame/Slice92,
	$RotatorFrame/Slice93
]
@onready var endcaps = [
	$VBoxContainer/Frame/SliceCapA, 
	$VBoxContainer/Frame/SliceCapB, 
	$VBoxContainer/Frame/SliceCapC, 
	$VBoxContainer/Frame/SliceCapD, 
]

#region UI handling
func pos_to_rot(pos: int) -> float:
	return fmod((360.0 / WHEEL_SIZE * pos), 360.0)

func rotate_rotator(old_pos: int):
	var old_rot = pos_to_rot(old_pos)
	$RotatorFrame.rotation_degrees = old_rot
	var tween = create_tween()
	tween.tween_property($RotatorFrame, "rotation_degrees", old_rot + 90, 0.3)

@export var rotation_position: int = 0:
	set(value):
		rotation_position = value % 4
#endregion

func get_flavor(index: int = 0) -> SliceData.Flavors:
	return _contents[posmod(index - rotation_position, 4)]
	
func set_flavor(index: int = 0, flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	_contents[posmod(index - rotation_position, 4)] = flavor

func mid_turn():
	update_slices()
	rotate_rotator(rotation_position)
	await get_tree().create_timer(0.3).timeout
	rotation_position += 1
	if get_flavor(0) == SliceData.Flavors.NO_SLICE and input_buffers:
		for buffer in input_buffers:
			if buffer.get_flavor(0) != SliceData.Flavors.NO_SLICE:
				set_flavor(0, buffer.pop_slice())
				break
	update_slices()
