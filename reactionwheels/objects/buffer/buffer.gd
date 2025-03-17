@tool
extends Control

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
		if len(value) > self.content_size:
			contents = value.slice(0, self.content_size)
		else:
			contents = value
		await verify_ready()
		var cont_children = slot_container.get_children()
		for i in len(contents):
			cont_children[i].flavor = contents[i]
		for i in range(len(contents), self.content_size, 1):
			cont_children[i].flavor = SliceData.Flavors.NO_SLICE

@export var buffer_name: String = "NEW BUFFER":
	set(value):
		buffer_name = value
		await verify_ready()
		$PanelContainer/VBoxContainer/NameLabel.text = buffer_name
#endregion

#region operating functions
func _ready() -> void:
	self.prune_contents()
#endregion

#region functional functions
func prune_contents():
	"""Remove all NO_SLICE slices from this"""
	if self.contents.find(SliceData.Flavors.NO_SLICE) == -1:
		return
	var new_contents = []
	for slice in self.contents:
		if slice != SliceData.Flavors.NO_SLICE:
			new_contents.append(slice)
	print(
		"Pruned %d from buffer %s" 
		% [(len(contents) - len(new_contents)), self.buffer_name]
	)
	self.contents = new_contents

func is_full() -> bool:
	self.prune_contents()
	return len(self.contents) == self.content_size

func add_slice(slice: SliceData.Flavors) -> void:
	if slice == SliceData.Flavors.NO_SLICE:
		return
	if is_full():
		self.slice_buffer_overflow.emit(slice)
		return
	var update_index = len(self.contents)
	self.contents.append(slice)
	slot_container.get_children()[update_index].flavor = slice
	
func pop_slice(loc: int = 0) -> SliceData.Flavors:
	if len(self.contents) == 0:
		return SliceData.Flavors.NO_SLICE
	var popped_slice = self.contents[0]
	self.contents = self.contents.slice(1)
	return popped_slice
#endregion
