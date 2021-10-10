extends Node2D

const BEAM = preload("res://src/level_mechanics/Beam.tscn")

export(bool) var enabled = false
export(bool) var debug = false
export(String, "up", "down", "left", "right") var orientation = "right"

var sub_beams = []

onready var main_beam = $Beam


func _ready():
	if orientation == "right":
		main_beam.cast_to = Vector2(1000, 0)
	elif orientation == "down":
		main_beam.cast_to = Vector2(0, 1000)
	elif orientation == "left":
		main_beam.cast_to = Vector2(-1000, 0)
	else:
		main_beam.cast_to = Vector2(0, -1000)


func _process(delta):
	for i in range(0, sub_beams.size()):
		if !main_beam.reflecting && sub_beams[i].is_casting:
			while (sub_beams.size() > 0):
				sub_beams[i].queue_free()
				sub_beams.remove(i)
			break
		if !sub_beams[i].reflecting:
			while (sub_beams.size() > i + 1):
				sub_beams[i + 1].queue_free()
				sub_beams.remove(i + 1)
			break


func add_beam(pos, dir):
	var new_beam = BEAM.instance()
	add_child(new_beam)
	new_beam.position = pos
	new_beam.cast_to = dir
	sub_beams.append(new_beam)


func _on_Lever_enable():
	enabled = true
	main_beam._on_Lever_enable()


func _on_Lever_disable():
	enabled = false
	main_beam._on_Lever_disable()


func _on_LaserBase_enable():
	enabled = true
	main_beam._on_LaserBase_enable()
