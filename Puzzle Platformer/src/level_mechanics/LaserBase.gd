class_name LaserBase
extends Area2D

signal enable

export(String, "up", "down", "left", "right") var orientation = "up"

var powered = false

onready var sprite = $Sprite

func _ready():
	if orientation == "right":
		sprite.rotation_degrees = 90
	elif orientation == "down":
		sprite.rotation_degrees = 180
	elif orientation == "left":
		sprite.rotation_degrees = 270

func power_on():
	emit_signal("enable")
	powered = true
