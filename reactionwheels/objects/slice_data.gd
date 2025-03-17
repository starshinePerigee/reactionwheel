@tool
class_name SliceData
extends Object

#region base class
class SliceDef:
	var slice_name:String
	var s_icon:String
	var mod_color:Color
	
	func _init(name: String, icon: String, mut: Color):
		self.slice_name = name
		self.s_icon = icon
		self.mod_color = mut
#endregion

#region instances
static var NO_SLICE = SliceDef.new("null", "▪", Color("1c1c1c"))
static var TEST_SLICE = SliceDef.new("debug", "🔝", Color("f200ff"))
static var POWER = SliceDef.new("power", "⚡", Color("00fce3"))
static var HEAT = SliceDef.new("heat", "🔥", Color("e60010"))
#endregion

#region global instances
enum Slices {NO_SLICE, TEST_SLICE, POWER, HEAT}

static var FLAVOR_DICT = {
	Slices.NO_SLICE: NO_SLICE,
	Slices.TEST_SLICE: TEST_SLICE,
	Slices.POWER: POWER,
	Slices.HEAT: HEAT
}
#endregion
