@tool
extends PanelContainer

func _ready():
	$SliceBuffbox.color = false

@export var flavor: SliceData.Flavors = SliceData.Flavors.DEBUG:
	set(value):
		flavor = value
		if not is_node_ready():
			await ready
		$SliceBuffbox.flavor = flavor
