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
		var xCount = nExp.count("%s") - 1
		if exp.parse(nExp % valueArray(xCount)) != OK:
			push_error("expression didn't parse right for init rip lol")
		else:
			d[e] = {}
			d[e]["expression"] = nExp
			d[e]["vCount"] = xCount
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

func calc(i:String) -> float:
	if(d.has(i)):
		var exp = Expression.new()
		if(exp.parse(d[i]["expression"] % valueArray(d[i]["vCount"])) == OK):
			d[i]["value"] = exp.execute()
			return d[i]["value"]
		else:
			push_error("Something went wrong\nValue: %s\nExpression: %s\ninput: %s" % [value, d[i]["expression"], i])
	else:
		push_error("mf dict doesn't have %s as an attributetype" % i)
	return NAN

func valueArray(i:int) -> Array[float]:
	var e = []
	for c in range(i):
		e.append(value)
	return e

func calcAll() -> void:
	for e in d.keys():
		calc(e)
