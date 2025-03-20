@tool
extends Control
class_name Buffer

signal slice_buffer_overflow(slice: SliceData.Flavors)

var slice_buffbox = preload("res://objects/buffer/buffbox.tscn")

#region UI and export
@onready var slot_container = $VBoxContainer/PanelContainer2/HBoxContainer/SlotContainer

func _set_children_size():
	var cont_children = slot_container.get_children()
	var old_size = len(cont_children)
	if old_size > content_size:
		for i in range(old_size, content_size, -1):
			var to_pop = cont_children[i - 1]
			slot_container.remove_child(to_pop)
			to_pop.queue_free()
	elif old_size < content_size:
		for i in range(content_size - old_size):
			var segment = slice_buffbox.instantiate()
			segment.flavor = SliceData.Flavors.NO_SLICE
			segment.name = "SliceContainer%d" % (old_size + i)
			slot_container.add_child(segment)
			segment.owner = get_tree().edited_scene_root

@export var content_size: int = 4:
	set(value):
		content_size = value
		if content_size < 0:
			content_size = 0
		if not is_node_ready():
			await ready
		_set_children_size()

@export var contents: Array[SliceData.Flavors] = []:
	set(value):
		if len(value) > content_size:
			contents = value.slice(0, content_size)
		else:
			contents = value
		if not is_node_ready():
			await ready
		var cont_children = slot_container.get_children()
		for i in len(contents):
			cont_children[-i-1].flavor = contents[i]
		for i in range(len(contents), content_size, 1):
			cont_children[-i-1].flavor = SliceData.Flavors.NO_SLICE

@export var buffer_name: String = "NEW BUFFER":
	set(value):
		buffer_name = value
		if not is_node_ready():
			await ready
		$VBoxContainer/PanelContainer/NameLabel.text = buffer_name
#endregion

#region operating functions
func _ready() -> void:
	_set_children_size()
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
	slot_container.get_children()[-update_index-1].flavor = slice
	
func pop_slice(loc: int = 0) -> SliceData.Flavors:
	if len(contents) <= loc:
		return SliceData.Flavors.NO_SLICE
	var popped_slice = contents[loc]
	contents = contents.slice(0, loc) + contents.slice(loc+1)
	return popped_slice

func remove_flavor(flavor: SliceData.Flavors) -> bool:
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
