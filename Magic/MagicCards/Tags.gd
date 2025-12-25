class_name Tag

enum TAGS{
	OFFENSIVE,
	DEFENSIVE,
	FIRE,
	WATER,
	NATURE,
	LIGHT,
	DARK,
	ELECTRIC,
	ICE,
}

@export var tags : int

func has(hh : String) -> bool:
	var h : String = hh.to_upper() 
	if (exists(h)):
		@warning_ignore("integer_division")
		return (tags / 2**TAGS[h]) % 2 == 1
	return false

func add(hh : String) -> void:
	var h : String = hh.to_upper() 
	if exists(h):
		if !has(h):
			tags += 2**TAGS[h]

func addArray(h : Array[String]) -> void:
	for i : String in h:
		add(i)

func remove(hh : String) -> void:
	var h : String = hh.to_upper() 
	if exists(h):
		if has(h):
			tags -= 2**TAGS[h]

func exists(h : String) -> bool:
	if (TAGS.has(h)):
		return true
	else:
		push_error("the tag \"%s\" does not exist, bozo" % h)
		return false
	
