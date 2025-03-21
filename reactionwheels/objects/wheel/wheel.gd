@tool
extends Control
class_name Wheel

@onready var _actions: Array[Action] = [$ActionA, $ActionB, $ActionC, $ActionD]

func rebuild():
	if not is_node_ready():
		await ready
		
	var core: WheelCore = $WheelCore
	core.display_name = display_name
	core.input_buffers = input_buffers
	core.starting_contents = starting_contents
	for action in _actions:
		action.input_buffers = input_buffers
	
	var act_a: Action = $ActionA
	act_a.id_string = identifier_a
	act_a.activation_flavor = activation_flavor_a
	act_a.activation_slice = core.endcaps[0]
	act_a.reaction_input = input_flavors_a
	act_a.inputs_optional = input_optional_a
	act_a.reaction_output = output_flavors_a
	act_a.output_buffer = output_buffer_a
	act_a.cooldown = cooldown_a
	act_a.automatic = automatic_a
	
	var act_b: Action = $ActionB
	act_b.id_string = identifier_b
	act_b.activation_flavor = activation_flavor_b
	act_b.activation_slice = core.endcaps[1]
	act_b.reaction_input = input_flavors_b
	act_b.inputs_optional = input_optional_b
	act_b.reaction_output = output_flavors_b
	act_b.output_buffer = output_buffer_b
	act_b.cooldown = cooldown_b
	act_b.automatic = automatic_b
	
	var act_c: Action = $ActionC
	act_c.id_string = identifier_c
	act_c.activation_flavor = activation_flavor_c
	act_c.activation_slice = core.endcaps[2]
	act_c.reaction_input = input_flavors_c
	act_c.inputs_optional = input_optional_c
	act_c.reaction_output = output_flavors_c
	act_c.output_buffer = output_buffer_c
	act_c.cooldown = cooldown_c
	act_c.automatic = automatic_c
	
	var act_d: Action = $ActionD
	act_d.id_string = identifier_d
	act_d.activation_flavor = activation_flavor_d
	act_d.activation_slice = core.endcaps[3]
	act_d.reaction_input = input_flavors_d
	act_d.inputs_optional = input_optional_d
	act_d.reaction_output = output_flavors_d
	act_d.output_buffer = output_buffer_d
	act_d.cooldown = cooldown_d
	act_d.automatic = automatic_d
	
	for act in _actions:
		act.rebuild()

func _process(_delta: float) -> void:
	# what is a cpu fan besides more wheels:
	if Engine.is_editor_hint():
		rebuild()

func _ready() -> void:
	rebuild()

@export_category("Wheel Properties")
@export var display_name: String = "WHL 100 TEST_WHEEL"
@export var input_buffers: Array[Buffer] = []
@export var starting_contents: Array[SliceData.Flavors] = []

@export_category("Action A")
@export var identifier_a: String = "ACT A"
@export var activation_flavor_a: SliceData.Flavors = SliceData.Flavors.DEBUG
@export var input_flavors_a: Array[SliceData.Flavors] = []
@export var input_optional_a: bool = false
@export var output_flavors_a: Array[SliceData.Flavors] = []
@export var output_buffer_a: Buffer = null
@export var cooldown_a: int = 4
@export var automatic_a: bool = false

@export_category("Action B")
@export var identifier_b: String = "ACT B"
@export var activation_flavor_b: SliceData.Flavors = SliceData.Flavors.DEBUG
@export var input_flavors_b: Array[SliceData.Flavors] = []
@export var input_optional_b: bool = false
@export var output_flavors_b: Array[SliceData.Flavors] = []
@export var output_buffer_b: Buffer = null
@export var cooldown_b: int = 4
@export var automatic_b: bool = false

@export_category("Action C")
@export var identifier_c: String = "ACT C"
@export var activation_flavor_c: SliceData.Flavors = SliceData.Flavors.DEBUG
@export var input_flavors_c: Array[SliceData.Flavors] = []
@export var input_optional_c: bool = false
@export var output_flavors_c: Array[SliceData.Flavors] = []
@export var output_buffer_c: Buffer = null
@export var cooldown_c: int = 4
@export var automatic_c: bool = false

@export_category("Action D")
@export var identifier_d: String = "ACT D"
@export var activation_flavor_d: SliceData.Flavors = SliceData.Flavors.DEBUG
@export var input_flavors_d: Array[SliceData.Flavors] = []
@export var input_optional_d: bool = false
@export var output_flavors_d: Array[SliceData.Flavors] = []
@export var output_buffer_d: Buffer = null
@export var cooldown_d: int = 4
@export var automatic_d: bool = false


func action_pre():
	for action in _actions:
		action.action_pre()

func mid_turn():
	$WheelCore.mid_turn()

func action_post():
	for action in _actions:
		action.action_post()
