@tool
extends Control

func _collapse_array(a: Array[SliceData.Flavors]) -> Dictionary:
	var d = {}
	for f in a:
		if f not in d.keys():
			d[f] = a.count(f)
	return d

@export var contents: Array[SliceData.Flavors]:
	set(value):
		contents = value
		var d = _collapse_array(contents)
		if not is_node_ready():
			await ready
		var cont = $HBoxContainer
		for c in cont.get_children():
			cont.remove_child(c)
			c.queue_free()
		for f in d.keys():
			if d[f] >= 5:
				cont.add_child(Flavor.new(f))
				var l = Label.new()
				l.text = "x%d " % d[f]
				cont.add_child(l)
			else:
				for __ in d[f]:
					cont.add_child(Flavor.new(f))
		$HBoxContainer.add_theme_constant_override("separation", 3 - cont.get_child_count())
