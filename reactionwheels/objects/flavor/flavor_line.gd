@tool
extends Control

func _collapse_array(a: Array[SliceData.Flavors]) -> Dictionary:
	var d = {}
	for f in a:
		if f not in d.keys():
			d[f] = a.count(f)
	return d

func _update_contents():
		var d = _collapse_array(contents)
		if not is_node_ready():
			await ready
		for c in get_children():
			remove_child(c)
			c.queue_free()
		if optional:
			var o1 = Label.new()
			o1.text = "{  "
			add_child(o1)
		for f in d.keys():
			if d[f] >= 5:
				add_child(Flavor.new(f))
				var l = Label.new()
				l.text = " x%d " % d[f]
				add_child(l)
			else:
				for __ in d[f]:
					add_child(Flavor.new(f))
		if optional:
			var o2 = Label.new()
			o2.text = "  }"
			add_child(o2)
		add_theme_constant_override("separation", 5 - get_child_count() * 3)
	

@export var contents: Array[SliceData.Flavors]:
	set(value):
		contents = value
		_update_contents()
		
@export var optional: bool = false:
	set(value):
		optional = value
		_update_contents()
