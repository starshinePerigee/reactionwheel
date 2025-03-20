@tool
extends Control
class_name Wheel

func _ready() -> void:
	$ActionA.input_buffers = $WheelCore.input_buffers
	$ActionB.input_buffers = $WheelCore.input_buffers
	$ActionC.input_buffers = $WheelCore.input_buffers
	$ActionD.input_buffers = $WheelCore.input_buffers

func do_turn():
	$ActionA.do_turn()
	$ActionB.do_turn()
	$ActionC.do_turn()
	$ActionD.do_turn()
