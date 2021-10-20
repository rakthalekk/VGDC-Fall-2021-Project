extends Node2D

const BEAM = preload("res://src/level_mechanics/Beam.tscn")

export(bool) var enabled = false
export(String, "up", "down", "left", "right") var orientation = "right"
export(bool) var deadly = false

onready var main_beam = $Beam
onready var sprite = $Sprite
onready var enable_sound = $EnableSound


func _ready():
	if orientation == "right":
		main_beam.cast_to = Vector2(1000, 0)
		sprite.rotation_degrees = 90
	elif orientation == "down":
		main_beam.cast_to = Vector2(0, 1000)
		sprite.rotation_degrees = 180
	elif orientation == "left":
		main_beam.cast_to = Vector2(-1000, 0)
		sprite.rotation_degrees = 270
	else:
		main_beam.cast_to = Vector2(0, -1000)
		sprite.rotation_degrees = 0


func add_beam(p, pos, dir):
	var new_beam = BEAM.instance()
	add_child(new_beam)
	new_beam.position = pos
	new_beam.cast_to = dir
	p.sub_beams.append(new_beam)
	return new_beam


func _on_LaserBase_enable():
	enabled = true
	enable_sound.play()
	main_beam.enable()


func _on_Lever_flip():
	if enabled:
		enabled = false
		main_beam.reflecting = false
		main_beam.disable()
	else:
		enabled = true
		enable_sound.play()
		main_beam.enable()
