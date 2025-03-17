@tool
extends Control

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
					var segment = preload("res://objects/segment/segment.tscn").instantiate()
					segment.segment_type = Segment.SegmentTypes.BUFFBOX
					segment.slice = SliceData.Slices.NO_SLICE
					slot_container.add_child(segment)

@export var contents: Array[SliceData.Slices] = []:
	set(value):
		if len(value) > self.content_size:
			contents = value.slice(0, self.content_size)
		else:
			contents = value

@export var buffer_name: String = "NEW BUFFER":
	set(value):
		buffer_name = value
		await verify_ready()
		$PanelContainer/VBoxContainer/NameLabel.text = buffer_name
