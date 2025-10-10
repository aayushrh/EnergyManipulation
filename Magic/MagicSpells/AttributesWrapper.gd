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
	for e in attr.tags:
		
		var exp = Expression.new()
		var nExp = (e.expression.replace("x", "%s"))
		var xCount = nExp.count("%s")
		if (valueArray(xCount).size() > 0 and exp.parse(nExp % valueArray(xCount)) != OK) or (valueArray(xCount).size() == 0 and exp.parse(nExp) != OK):
			push_error("expression didn't parse right for init rip lol")
		else:
			d[e.name] = {}
			d[e.name]["expression"] = nExp
			d[e.name]["vCount"] = xCount
			d[e.name]["suffix"] = e.suffix
			d[e.name]["prefix"] = e.prefix
			d[e.name]["default"] = e.default
			d[e.name]["mult"] = pow(10, e.displayExpo)
			d[e.name]["value"] = exp.execute()
			d[e.name]["round"] = e.round
			d[e.name]["posColor"] = e.posColor
			d[e.name]["negColor"] = e.negColor
			d[e.name]["defColor"] = e.defColor
			d[e.name]["alias"] = e.alias if e.alias != "" else e.name
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
				d[i]["value"] = snappedf(exp.execute(), d[i]["round"])
				return d[i]["value"]
		else:
			if(exp.parse(d[i]["expression"]) == OK):
				d[i]["value"] = snappedf(exp.execute(), d[i]["round"])
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
	return "%s%s%s" % [d[pos]["prefix"], (d[pos]["value"] * d[pos]["mult"]), d[pos]["suffix"]]
