extends Area2D

signal enable
signal disable

export(bool) var on = false

onready var sprite = $Sprite
onready var flip_sound = $FlipSound

# Called when the node enters the scene tree for the first time.
func _ready():
	set_sprite_orientation()


func set_sprite_orientation():
	if on:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1


func _on_Lever_area_entered(area):
	flip_sound.play()
	on = !on
	set_sprite_orientation()
	if on:
		emit_signal("enable")
	else:
		emit_signal("disable")
