extends Node
class_name AttributesWrapper

var value : float = 0.0
var min : float = 0.0
var max : float = 0.0
var d : Dictionary = {} # Dictionary of [String, Dictionary]
var Ltext : String = ""
var Rtext : String = ""

func _init(attr:Attributes) -> void:
	value = attr.start
	var i = 0
	for e in attr.strings:
		
		var exp = Expression.new()
		var nExp = (attr.tags[i].expression.replace("x", "%s"))
		if exp.parse(nExp % value) != OK:
			push_error("expression didn't parse right for init rip lol")
		else:
			d[e] = {}
			d[e]["expression"] = nExp
			d[e]["suffix"] = attr.tags[i].suffix
			d[e]["prefix"] = attr.tags[i].prefix
			d[e]["default"] = attr.tags[i].default
			d[e]["value"] = exp.execute()
			d[e]["posColor"] = attr.tags[i].posColor
			d[e]["negColor"] = attr.tags[i].negColor
			d[e]["defColor"] = attr.tags[i].defColor
			d[e]["alias"] = attr.tags[i].alias if attr.tags[i].alias != "" else e
	min = attr.min
	max = attr.max
	Ltext = attr.Ltext
	Rtext = attr.Rtext
