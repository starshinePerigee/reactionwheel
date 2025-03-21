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

func rebuild():
	$TopLabel.text = id_string
	$TopBox/TopLine.contents = reaction_input
	$TopBox/TopLine.optional = inputs_optional
	$BottomBox/BottomLine.contents = reaction_output
	
	if automatic:
		texture_normal = texture_auto
		texture_pressed = texture_auto_sel
		#$TopLabel.text = "AUTO %s" % id_string
	else:
		texture_normal = texture_manual
		texture_pressed = texture_manual_sel
		#$TopLabel.text = "ACT %s" % id_string
			
	reset_turns_waiting()
	update_progress_indicators()
	action_post()
	update_activation_slice()
	
func update_progress_indicators():
	if not is_node_ready():
		await ready
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
		if automatic:
			$BotLabel.text = "AUTO %d/%d" % [turns_waiting, cooldown]
		else:
			$BotLabel.text = "READYING %d/%d" % [turns_waiting, cooldown]

func reset_turns_waiting() -> void:
	if automatic:
		turns_waiting = 0
	else:
		turns_waiting = cooldown

func update_activation_slice(skew: int = 0):
	if not is_node_ready():
		await ready
	if activation_slice:
		activation_slice.flavor = activation_flavor
		activation_slice.color = !await check_activation_cost(skew)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		rebuild()

func _ready() -> void:
	rebuild()

#region Exports
@export_group("Links")
@export var activation_object: Node
@export var activation_index: int
@export var activation_slice: Slice
@export var input_buffers: Array[Buffer]
@export var output_buffer: Buffer

@export_group("Action Properties")
@export var id_string: String = "000"
@export var automatic: bool = false
@export var cooldown: int = 4
@export var turns_waiting: int = 0

@export_group("Reaction")
@export var activation_flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE
@export var reaction_input: Array[SliceData.Flavors] = []
		
@export var reaction_output: Array[SliceData.Flavors] = []
@export var inputs_optional: bool = false
#endregion

#region utility and upkeep
var action_ready: bool:
	get():
		return turns_waiting >= cooldown

func _on_action_body_pressed() -> void:
	clicked.emit()
	if not automatic:
		if await full_activation():
			manual_completed.emit()

func check_activation_cost(skew: int = 0) -> bool:
	"""Checks if the activation cost (just slice:slice) is met."""
	if activation_object == null:
		return true
	if not activation_object.is_node_ready():
		await activation_object.ready
	if activation_object.get_flavor(activation_index - skew) == activation_flavor:
		return true
	if (
		activation_flavor == SliceData.Flavors.ANY_SLICE and
		activation_object.get_flavor(activation_index - skew) != SliceData.Flavors.NO_SLICE
	):
		return true
	return false
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
	if reaction_output and output_buffer:
		for flavor in reaction_output:
			output_buffer.add_slice(flavor)
	activated.emit()

func action_pre():
	if automatic:
		full_activation()
	if not action_ready:
		turns_waiting += 1

func action_post():
	update_progress_indicators()
	update_activation_slice(1)
		
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
	return true

#endregion
