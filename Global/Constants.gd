extends Node

func isValidElement(a):
	var elements = ["fire", "water", "nature", "light", "dark", "electric"]
	for e in elements:
		if(e == (a.to_lower())):
			return true
	return false

func isValidStyle(a):
	var elements = ["dragon", "tiger", "rabbit", "horse", "monkey", "rat", "boar"]
	for e in elements:
		if(e == (a.to_lower())):
			return true
	return false

func isValidType(a):
	var elements = ["blast", "explosion", "placed explosion", "beam", "aura"]
	for e in elements:
		if(e == (a.to_lower())):
			return true
	return false


func isValid(a):
	if(a==null):
		return false
	match(a.type):
		0:
			return isValidElement(a.spellName)
		1:
			return isValidStyle(a.spellName)
		2:
			return isValidType(a.spellName)
	printerr("invalid type you fuck")
