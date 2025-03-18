@tool
extends TextureButton

static var body_clickmask = BitMap.new()
	
func _ready():
	body_clickmask.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = body_clickmask
