@tool
extends Control
class_name Buffer

signal slice_buffer_overflow(slice: SliceData.Flavors)

var endcap = preload("res://assets/objects/buffer_cap.svg")
var slice_buffbox = preload("res://objects/buffer/buffbox.tscn")

#region UI and export
@onready var slot_container = $VBoxContainer/PrimaryContainer

@export_range(0, 100) var content_size: int = 4:
	set(value):
		content_size = value
		_rebuild_children()

@export_range(1, 10) var row_count: int = 1:
	set(value):
		row_count = value
		_rebuild_children()

var container_map: Dictionary = {}

func _rebuild_children():
	if not is_node_ready():
		await ready
	container_map = {}
	for c in slot_container.get_children():
		slot_container.remove_child(c)
		c.queue_free()
	var items_per_row = int(ceil((float(content_size) + 2) / row_count))
	var hbox = null
	for i in range(2 + content_size):
		if i % items_per_row == 0:
			hbox = HBoxContainer.new()
			hbox.add_theme_constant_override("separation", -3)
			slot_container.add_child(hbox)
		var next = null
		if i == 0 or i == content_size + 1:
			next = TextureRect.new()
			next.texture = endcap
		else:
			next = slice_buffbox.instantiate()
			next.flavor = SliceData.Flavors.NO_SLICE
			container_map[i - 1] = next
		hbox.add_child(next)
	slot_container.get_children()[-1].alignment = BoxContainer.ALIGNMENT_END

@export var contents: Array[SliceData.Flavors] = []:
	set(value):
		if len(value) > content_size:
			contents = value.slice(0, content_size)
		else:
			contents = value
		if not is_node_ready():
			await ready
		for i in len(contents):
			container_map[content_size-i-1].flavor = contents[i]
		for i in range(len(contents), content_size, 1):
			container_map[content_size-i-1].flavor = SliceData.Flavors.NO_SLICE

@export var buffer_name: String = "NEW BUFFER":
	set(value):
		buffer_name = value
		if not is_node_ready():
			await ready
		$VBoxContainer/PanelContainer/NameLabel.text = buffer_name
#endregion

#region operating functions
func _ready() -> void:
	_rebuild_children()
	prune_contents()
#endregion

#region functional functions
func prune_contents() -> void:
	"""Remove all NO_SLICE slices from this"""
	if contents.find(SliceData.Flavors.NO_SLICE) == -1:
		return
	var new_contents: Array[SliceData.Flavors] = []
	for slice in contents:
		if slice != SliceData.Flavors.NO_SLICE:
			new_contents.append(slice)
	print(
		"Pruned %d from buffer %s" 
		% [(len(contents) - len(new_contents)), buffer_name]
	)
	contents = new_contents

func is_full() -> bool:
	prune_contents()
	return len(contents) == content_size

func add_slice(slice: SliceData.Flavors) -> void:
	if slice == SliceData.Flavors.NO_SLICE:
		return
	if is_full():
		slice_buffer_overflow.emit(slice)
		return
	var update_index = len(contents)
	contents.append(slice)
	container_map[content_size-update_index-1].flavor = slice
	
func pop_slice(loc: int = 0) -> SliceData.Flavors:
	if len(contents) <= loc:
		return SliceData.Flavors.NO_SLICE
	var popped_slice = contents[loc]
	contents = contents.slice(0, loc) + contents.slice(loc+1)
	return popped_slice

func remove_flavor(flavor: SliceData.Flavors, _dest: Vector2 = Vector2(-383, 0)) -> bool:
	var idx = contents.find(flavor)
	if idx < 0:
		return false
	pop_slice(idx)
	return true
	
func clear_contents() -> void:
	contents = []
	
func get_flavor(index: int = 0) -> SliceData.Flavors:
	if index >= len(contents):
		return SliceData.Flavors.NO_SLICE
	return contents[index]
	
func set_flavor(index: int = 0, flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	contents[index] = flavor
	if flavor == SliceData.NO_SLICE:
		prune_contents()
#endregion

func action_pre():
	pass

func mid_turn():
	pass

func action_post():
	pass
