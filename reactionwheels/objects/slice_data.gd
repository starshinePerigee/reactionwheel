@tool
class_name SliceData
extends Object

#region base class
class FlavorDef:
	var flavor_name:String
	var f_icon:String
	var mod_color:Color
	
	func _init(name: String, icon: String, mut: Color):
		self.flavor_name = name
		self.f_icon = icon
		self.mod_color = mut
#endregion

#region instances
static var NO_SLICE = FlavorDef.new("null", "▪", Color("1c1c1c"))
static var TEST_SLICE = FlavorDef.new("debug", "🔝", Color("f200ff"))
static var POWER = FlavorDef.new("power", "⚡", Color("00fce3"))
static var HEAT = FlavorDef.new("heat", "🔥", Color("e60010"))
#endregion

#region global instances
enum Flavors {NO_SLICE, TEST_SLICE, POWER, HEAT}

static var FLAVOR_DICT = {
	Flavors.NO_SLICE: NO_SLICE,
	Flavors.TEST_SLICE: TEST_SLICE,
	Flavors.POWER: POWER,
	Flavors.HEAT: HEAT
}
#endregion
