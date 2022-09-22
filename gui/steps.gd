extends Node

var steps = []

func addStep():
	var step = []

	for objekt in $"../../Objekty".get_children():
		if not objekt.name in ["Tiles", "Citat"]:
			if objekt.name.substr(0, 6) == "Listie":
				var count_sprites = 0

				for sprite in objekt.get_node("Sprites").get_children():
					if sprite.visible: count_sprites += 1

				step.append([objekt.name, objekt.position, count_sprites])
			else:
				step.append([objekt.name, objekt.position])

	steps.append(step)

func undo():
	if steps.size():
		MusicController.playClick()

		for step in steps[-1]:
			var objekty = $"../../Objekty"

			if objekty.has_node(step[0]):
				var objekt = objekty.get_node(step[0])
				objekt.position = step[1]

				if step[0].substr(0, 6) == "Listie":
					var count_sprites = 0

					for sprite in objekt.get_node("Sprites").get_children():
						if sprite.visible: count_sprites += 1
						if count_sprites > step[2]: sprite.visible = false
			else:
				objekty.add_child(load("res://game/Listie.tscn").instance())

				var added_leaf = objekty.get_child(objekty.get_child_count()-1)
				added_leaf.name = step[0]
				added_leaf.position = step[1]
				added_leaf.setVisibleSprites(added_leaf, step[2] - 1)

				var kos = objekty.get_node("Kos")
				if kos.modulate.a == 1: kos.modulate.a = 0.470588

		steps.remove(steps.size() - 1)
