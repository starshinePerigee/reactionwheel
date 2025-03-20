@tool
class_name SliceData
extends Object

#region base class

class FlavorDef:
	static func _get_texture(f: String, v: String) -> Resource:
		var res_str = "res://assets/icons/%s%s.svg" % [f, v]
		if FileAccess.file_exists(res_str):
			return load(res_str)
		else:
			return load("res://assets/icons/debug%s.svg" % v)
	
	var flavor_name:String
	var mod_color:Color
	var icon_color:Resource
	var icon_black:Resource
	var icon_large:Resource
	
	func _init(name: String, mut: Color):
		self.flavor_name = name
		self.mod_color = mut
		self.icon_color = _get_texture(name, "_color")
		self.icon_black = _get_texture(name, "_black")
		self.icon_large = _get_texture(name, "")
#endregion

#region instances
static var NO_SLICE = FlavorDef.new("no_slice", Color("333333"))
static var DEBUG = FlavorDef.new("debug", Color("d63384"))
static var POWER = FlavorDef.new("power", Color("17a2b8"))
static var HEAT = FlavorDef.new("heat", Color("fd7e14"))
static var SIGNAL = FlavorDef.new("signal", Color("FFFFFF"))
static var DAMAGE = FlavorDef.new("damage", Color("FFFFFF"))
static var STAR = FlavorDef.new("success", Color("FFFFFF"))
#endregion

#region global instances
enum Flavors {NO_SLICE, DEBUG, POWER, HEAT, SIGNAL, DAMAGE, STAR}

static var FLAVOR_DICT = {
	Flavors.NO_SLICE: NO_SLICE,
	Flavors.DEBUG: DEBUG,
	Flavors.POWER: POWER,
	Flavors.HEAT: HEAT,
	Flavors.SIGNAL: SIGNAL,
	Flavors.DAMAGE: DAMAGE,
	Flavors.STAR: STAR
}
#endregion
