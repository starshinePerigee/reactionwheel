@tool
extends Control
class_name Action

signal clicked
signal activated
signal manual_completed

func verify_ready():
	if not is_node_ready():
		await ready

#region Exports
@export_group("Links")
@export var activation_object: Node
@export var activation_index: int
@export var input_buffer: Buffer
@export var output_buffer: Buffer

@export_group("Action Properties")
@export var automatic: bool = false:
	set(value):
		automatic = value
		await verify_ready()
		$AutoBody.visible = automatic

func update_progress_label():
	$ProgressBar/ProgressLabel.text = "%d / %d" % [turns_waiting, cooldown]

@export var cooldown: int = 4:
	set(value):
		cooldown = value
		await verify_ready()
		$ProgressBar.max_value = value
		update_progress_label()
		reset_turns_waiting()

@export var turns_waiting: int = 0:
	set(value):
		turns_waiting = value
		await verify_ready()
		$ProgressBar.value = turns_waiting
		update_progress_label()

func reset_turns_waiting() -> void:
	if automatic:
		turns_waiting = 0
	else:
		turns_waiting = cooldown

@export_group("Reaction")
@export var has_activation: bool = true:
	set(value):
		has_activation = value
		await verify_ready()
		$Tail.visible = has_activation

@export var activation_flavors: Array[SliceData.Flavors] = [SliceData.Flavors.TEST_SLICE]:
	set(value):
		activation_flavors = value
		await verify_ready()
		if len(activation_flavors) == 1:
			$Tail/TailSlice.visible = true
			$Tail/TailSlice.flavor = activation_flavors[0]
			$Tail/TailMulti.visible = false
			$Tail/Shade.visible = true
		else:
			$Tail/TailSlice.visible = false
			$Tail/TailMulti.visible = true
			$Tail/TailMulti/SliceLine.contents = activation_flavors
			$Tail/TailMulti/SliceLine.append_plus = len(activation_flavors) == 0
			$Tail/Shade.visible = len(activation_flavors) > 0

@export var reaction_input: Array[SliceData.Flavors] = [SliceData.Flavors.TEST_SLICE]:
	set(value):
		reaction_input = value
		await verify_ready()
		$HBoxContainer/InLine.contents = reaction_input
		
@export var reaction_output: Array[SliceData.Flavors] = [SliceData.Flavors.TEST_SLICE]:
	set(value):
		reaction_output = value
		await verify_ready()
		$HBoxContainer/OutLine.contents = reaction_output

@export var inputs_optional: bool = false:
	set(value):
		inputs_optional = value
		await verify_ready()
		$HBoxContainer/InLine.append_plus = inputs_optional
#endregion

#region utility and upkeep
var action_ready: bool:
	get():
		return turns_waiting >= cooldown

func _ready() -> void:
	reset_turns_waiting()

func _on_action_body_pressed() -> void:
	clicked.emit()
	if not automatic:
		if full_activation():
			manual_completed.emit()

func check_activation_cost() -> bool:
	if activation_object != null:
		var ok = (
			len(activation_flavors) == 0
			or activation_object.get_flavor(activation_index) in activation_flavors
		)
		$Tail/Shade.visible = !ok
		return ok
	return true

func update():
	check_activation_cost()
#endregion

#region core logic
func do_activation():
	# This function performs the activated logic, but does not check for compatibility
	if reaction_input:
		for flavor in reaction_input:
			input_buffer.remove_flavor(flavor)
	if reaction_output:
		for flavor in reaction_output:
			output_buffer.add_slice(flavor)
	activated.emit()

func do_turn():
	if automatic:
		full_activation()
	if not action_ready:
		turns_waiting += 1

func post_turn():
	if activation_object and activation_object.get_flavor(activation_index) not in activation_flavors:
		$Tail/Shade.visible = true
	else:
		$Tail/Shade.visible = false
		
func check_requirements() -> bool:
	# check cooldown:
	if not action_ready:
		return false
	if not inputs_optional and len(reaction_input) > 0:
		if not input_buffer:
			return false
		for in_flavor in reaction_input:
			# if there's multiple inputs of the same type this checks it redundantly
			# but its a game jam so yolo
			if reaction_input.count(in_flavor) > input_buffer.contents.count(in_flavor):
				return false
	if (
		activation_object
		and len(activation_flavors) > 0
		and not automatic 
		and activation_object.get_flavor(activation_index) == SliceData.Flavors.NO_SLICE
	):
		return false
	return true

func full_activation() -> bool:
	if not check_requirements():
		return false
	if activation_object:
		if activation_object.get_flavor(activation_index) in activation_flavors:
			do_activation()
		activation_object.set_flavor(activation_index, SliceData.Flavors.NO_SLICE)
	else:
		do_activation()
	turns_waiting = 0
	return true

#endregion
