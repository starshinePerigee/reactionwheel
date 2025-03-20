@tool
extends TextureButton
class_name Action

signal clicked
signal activated
signal manual_completed

static var texture_manual = preload("res://assets/objects/action_base.svg")
static var texture_manual_sel = preload("res://assets/objects/action_base_selected.svg")
static var texture_auto = preload("res://assets/objects/action_auto.svg")
static var texture_auto_sel = preload("res://assets/objects/action_auto_selected.svg")

func verify_ready():
	if not is_node_ready():
		await ready

#region Exports
@export_group("Links")
@export var activation_object: Node
@export var activation_index: int
@export var activation_slice: Slice:
	set(value):
		activation_slice = value
		await verify_ready()
		update_activation_slice()
@export var input_buffers: Array[Buffer]
@export var output_buffer: Buffer

@export_group("Action Properties")

func _configure_automatic():
	await verify_ready()
	if automatic:
		texture_normal = texture_auto
		texture_pressed = texture_auto_sel
		$TopLabel.text = "AUTO %s" % id_string
	else:
		texture_normal = texture_manual
		texture_pressed = texture_manual_sel
		$TopLabel.text = id_string
		#$TopLabel.text = "ACT %s" % id_string

@export var id_string: String = "000":
	set(value):
		id_string = value
		_configure_automatic()

@export var automatic: bool = false:
	set(value):
		automatic = value
		_configure_automatic()
		reset_turns_waiting()

func update_progress_indicators():
	await verify_ready()
	if turns_waiting >= cooldown:
		disabled = false
		$ProgressWipe.position = Vector2(0, 0)
		$ProgressWipe.visible = false
		if automatic:
			$BotLabel.text = "ACTIVE"
		else:
			$BotLabel.text = "PRIMED"
	else:
		disabled = true
		var progress_pos = float(turns_waiting - 1) / float(cooldown - 1) * size.x
		progress_pos = max(progress_pos, 0)
		$ProgressWipe.position = Vector2(progress_pos, 0)
		$ProgressWipe.visible = true
		$BotLabel.text = "%d/%d" % [turns_waiting, cooldown]

@export var cooldown: int = 4:
	set(value):
		cooldown = value
		update_progress_indicators()
		reset_turns_waiting()

@export var turns_waiting: int = 0:
	set(value):
		turns_waiting = value
		update_progress_indicators()
#
func reset_turns_waiting() -> void:
	if automatic:
		turns_waiting = 0
	else:
		turns_waiting = cooldown

@export_group("Reaction")
@export var activation_flavor: SliceData.Flavors = SliceData.Flavors.DEBUG:
	set(value):
		activation_flavor = value
		await verify_ready()
		update_activation_slice()

@export var reaction_input: Array[SliceData.Flavors] = [SliceData.Flavors.DEBUG]:
	set(value):
		reaction_input = value
		await verify_ready()
		$TopBox/TopLine.contents = reaction_input
		
@export var reaction_output: Array[SliceData.Flavors] = [SliceData.Flavors.DEBUG]:
	set(value):
		reaction_output = value
		await verify_ready()
		$BottomBox/BottomLine.contents = reaction_output

@export var inputs_optional: bool = false:
	set(value):
		inputs_optional = value
		await verify_ready()
		$TopBox/TopLine.optional = inputs_optional
#endregion

#region utility and upkeep
var action_ready: bool:
	get():
		return turns_waiting >= cooldown

func _ready() -> void:
	reset_turns_waiting()
	update_activation_slice()

func _on_action_body_pressed() -> void:
	clicked.emit()
	if not automatic:
		if await full_activation():
			manual_completed.emit()

func check_activation_cost() -> bool:
	"""Checks if the activation cost (just slice:slice) is met."""
	if activation_object == null:
		return true
	if not activation_object.is_node_ready():
		await activation_object.ready
	if activation_object.get_flavor(activation_index) == activation_flavor:
		return true
	if (
		activation_flavor == SliceData.Flavors.ANY_SLICE and
		activation_object.get_flavor(activation_index) != SliceData.Flavors.NO_SLICE
	):
		return true
	return false

func update_activation_slice():
	await verify_ready()
	if activation_slice:
		activation_slice.flavor = activation_flavor
		activation_slice.colored = await check_activation_cost()

func update():
	update_activation_slice()
#endregion

#region core logic
func do_activation():
	# This function performs the activated logic, but does not check for compatibility
	if not await check_activation_cost():
		return
	if reaction_input:
		for flavor in reaction_input:
			for buffer in input_buffers:
				if flavor in buffer.contents:
					buffer.remove_flavor(flavor)
					continue
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
	if activation_slice and activation_object:
		if await check_activation_cost():
			activation_slice.colored = false
		else:
			activation_slice.colored = true
		
func check_requirements() -> bool:
	"""Checks all requirements, including slice:slice activation cost"""
	# check cooldown:
	if not action_ready:
		return false
	if not inputs_optional and len(reaction_input) > 0:
		if len(input_buffers) == 0:
			return false
		for in_flavor in reaction_input:
			# if there's multiple inputs of the same type this checks it redundantly
			# but its a game jam so yolo
			# prolly could update to use the logic from flavorline?
			var f_count = 0
			for buffer in input_buffers:
				f_count += buffer.contents.count(in_flavor)
			if reaction_input.count(in_flavor) > f_count:
				return false
	if not automatic and activation_object != null:
		if not activation_object.is_node_ready():
			await activation_object.ready	
		if activation_object.get_flavor(activation_index) == SliceData.Flavors.NO_SLICE:
			return false
	return true

func full_activation() -> bool:
	if not await check_requirements():
		return false
	do_activation()
	if activation_object:
		activation_object.set_flavor(activation_index, SliceData.Flavors.NO_SLICE)
	turns_waiting = 0
	update_activation_slice()
	return true

#endregion
