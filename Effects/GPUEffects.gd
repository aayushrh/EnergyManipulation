extends GPUParticles2D

func _setScale(nscale):
	scale = nscale
	process_material.set("scale", nscale)
	for i in get_children():
		if i is GPUParticles2D:
			i.process_material.set("scale", nscale)
