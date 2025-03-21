@tool
extends PanelContainer

signal fired

@onready var act = $Action

func rebuild():
	act.input_buffers = input_buffers
	act.id_string = identifier
	act.reaction_input = input_flavors
	act.inputs_optional = input_optional
	act.reaction_output = output_flavors
	act.output_buffer = output_buffer
	act.cooldown = cooldown
	act.automatic = automatic
	act.rebuild()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		rebuild()

func _ready() -> void:
	rebuild()

@export_category("Action")
@export var input_buffers: Array[Buffer]
@export var identifier: String = "ACT X"
@export var input_flavors: Array[SliceData.Flavors] = []
@export var input_optional: bool = false
@export var output_flavors: Array[SliceData.Flavors] = []
@export var output_buffer: Buffer = null
@export var cooldown: int = 4
@export var automatic: bool = false

func action_pre():
	act.action_pre()

func mid_turn():
	pass

func action_post():
	act.action_post()


func _on_action_manual_completed() -> void:
	fired.emit()
