@tool
class_name SliceData
extends Object

#region base class
class SliceDef:
	var name:String
	var icon:String
	var mod_color:Color
	
	func _init(name: String, icon: String, mut: Color):
		self.name = name
		self.icon = icon
		self.mod_color = mut
#endregion

#region instances
static var NO_SLICE = SliceDef.new("null", "▪", Color("1c1c1c"))
static var TEST_SLICE = SliceDef.new("debug", "❎", Color("f200ff"))
static var POWER = SliceDef.new("power", "⚡", Color("ffcc00"))
static var HEAT = SliceDef.new("heat", "🔥", Color("e60010"))
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
