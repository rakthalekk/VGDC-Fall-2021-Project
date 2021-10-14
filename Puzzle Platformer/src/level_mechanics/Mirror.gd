class_name Mirror
extends Area2D

export(String, "up", "down") var orientation = "up"

var update_orientation = false

onready var sprite = $Sprite
onready var flip_sound = $FlipSound

# Called when the node enters the scene tree for the first time.
func _ready():
	update_sprite()


func update_sprite():
	if orientation == "down":
		sprite.scale.y = -1
	else:
		sprite.scale.y = 1


func update_or():
	flip_sound.play()
	if orientation == "up":
		orientation = "down"
	else:
		orientation = "up"
	update_orientation = true
	update_sprite()


func _on_Lever_enable():
	update_or()


func _on_Lever_disable():
	update_or()


func _on_LaserSensor_enable():
	update_or()

