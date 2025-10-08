extends Node
class_name AttributesWrapper

var value : float = 0.0 : set = _updateValue
var min : float = 0.0
var max : float = 0.0
var d : Dictionary = {} # Dictionary of [String, Dictionary]
var Ltext : String = ""
var Rtext : String = ""
var step : float = 1.0
var attr : Attributes = null

func _init(attri:Attributes) -> void:
	attr = attri
	var i = 0
	for e in attr.strings:
		
		var exp = Expression.new()
		var nExp = (attr.tags[i].expression.replace("x", "%s"))
		var xCount = nExp.count("%s")
		print(valueArray(xCount).size())
		if (valueArray(xCount).size() > 0 and exp.parse(nExp % valueArray(xCount)) != OK) or (valueArray(xCount).size() == 0 and exp.parse(nExp) != OK):
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
		i += 1
	min = attr.min
	max = attr.max
	Ltext = attr.Ltext
	Rtext = attr.Rtext
	step = attr.step
	value = attr.start

func calc(i:String) -> float:
	if(d.has(i)):
		var exp = Expression.new()
		var x = valueArray(d[i]["vCount"])
		if(len(x)>0):
			if(exp.parse(d[i]["expression"] % x) == OK):
				d[i]["value"] = exp.execute()
				return d[i]["value"]
		else:
			if(exp.parse(d[i]["expression"]) == OK):
				d[i]["value"] = exp.execute()
				return d[i]["value"]
		push_error("Something went wrong\nValue: %s\nExpression: %s\ninput: %s" % [value, d[i]["expression"], i])
	else:
		push_error("mf dict doesn't have %s as an attributetype" % i)
	return NAN

func valueArray(i:int) -> Array:
	var e = []
	for c in range(i):
		e.append(value)
	return e

func calcAll() -> void:
	for e in d.keys():
		calc(e)

func gradient(c1: Color, c2: Color, blend: float) -> Color:
	var c = c1
	c += (c2-c1)*blend
	return c

func getColor(key: String) -> Color:
	return d[key]["posColor"] if d[key]["value"] > d[key]["default"] else d[key]["negColor"] if d[key]["value"] != d[key]["default"] else d[key]["defColor"]

func _updateValue(newValue: float) -> bool:
	if(value != newValue):
		var tValue = max(min(newValue, max), min)
		if (newValue != tValue):
			push_error("Somehow value(%s) was out of bounds (min = %s, max = %s)" % [newValue, min, max])
		value = tValue
		calcAll()
		return true
	return false

func getValueString(pos: String) -> String:
	return "%s%s%s" % [d[pos]["prefix"], d[pos]["value"], d[pos]["suffix"]]
