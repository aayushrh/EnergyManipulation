extends Node
class_name AttributesWrapper

var value : float = 0.0
var min : float = 0.0
var max : float = 0.0
var d : Dictionary = {}
var Ltext : String = ""
var Rtext : String = ""

func _init(attr:Attributes) -> void:
	value = attr.start
	var i = 0
	for e in attr.strings:
		if(attr.tags[i].has("expression")):
			var exp = Expression.new().parse(attr.tags[i]["expression"], ["x"])
			if exp != OK:
				push_error("expression didn't parse right rip lol")
			else:
				d[e] = {"expression":exp}
				d[e]["suffix"] = attr.tags[i]["suffix"] if (attr.atgs[i].has("suffix")) else ""
				d[e]["prefix"] = attr.tags[i]["prefix"] if (attr.atgs[i].has("prefix")) else ""
				d[e]["default"] = attr.tags[i]["default"] if (attr.atgs[i].has("default")) else 0.0
				d[e]["posColor"] = attr.tags[i]["posColor"] if (attr.atgs[i].has("suffix")) else Color(0, 1, 0)
				d[e]["negColor"] = attr.tags[i]["negColor"] if (attr.atgs[i].has("negColor")) else Color(1, 0, 0)
				d[e]["defColor"] = attr.tags[i]["defColor"] if (attr.atgs[i].has("defColor")) else Color(.7, .7, .7)
		else:
			push_error("Didn't have an expression for %s" % [e])
	min = attr.min
	max = attr.max
	Ltext = attr.Ltext
	Rtext = attr.Rtext
