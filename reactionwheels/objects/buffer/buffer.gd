@tool
extends Control
class_name Buffer

signal slice_buffer_overflow(slice: SliceData.Flavors)

#region UI and export
var slice_slot = preload("res://objects/slice/slice.tscn")

func verify_ready():
	if not is_node_ready():
		await ready

@onready var slot_container = $PanelContainer/VBoxContainer/SlotContainer

@export var content_size: int = 4:
	set(value):
		content_size = value
		if content_size < 0:
			content_size = 0
		await verify_ready()
		if slot_container != null:
			var cont_children = slot_container.get_children()
			var old_size = len(cont_children)
			if old_size > content_size:
				for i in range(old_size, content_size, -1):
					var to_pop = cont_children[i - 1]
					slot_container.remove_child(to_pop)
					to_pop.queue_free()
			elif old_size < content_size:
				for i in range(content_size - old_size):
					var segment = slice_slot.instantiate()
					segment.slice_type = Slice.SliceTypes.BUFFBOX
					segment.flavor = SliceData.Flavors.NO_SLICE
					segment.name = "SliceContainer%d" % (old_size + i)
					slot_container.add_child(segment)
					segment.owner = get_tree().edited_scene_root

@export var contents: Array[SliceData.Flavors] = []:
	set(value):
		if len(value) > content_size:
			contents = value.slice(0, content_size)
		else:
			contents = value
		await verify_ready()
		var cont_children = slot_container.get_children()
		for i in len(contents):
			cont_children[i].flavor = contents[i]
		for i in range(len(contents), content_size, 1):
			cont_children[i].flavor = SliceData.Flavors.NO_SLICE

@export var buffer_name: String = "NEW BUFFER":
	set(value):
		buffer_name = value
		await verify_ready()
		$PanelContainer/VBoxContainer/NameLabel.text = buffer_name
#endregion

#region operating functions
func _ready() -> void:
	prune_contents()
#endregion

#region functional functions
func prune_contents():
	"""Remove all NO_SLICE slices from this"""
	if contents.find(SliceData.Flavors.NO_SLICE) == -1:
		return
	var new_contents = []
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
	slot_container.get_children()[update_index].flavor = slice
	
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
	return contents[index]
	
func set_flavor(index: int = 0, flavor: SliceData.Flavors = SliceData.Flavors.NO_SLICE) -> void:
	contents[index] = flavor
	if flavor == SliceData.NO_SLICE:
		prune_contents()
#endregion
