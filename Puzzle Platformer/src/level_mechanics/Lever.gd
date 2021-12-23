extends Area2D

signal flip

export(bool) var on = false
export(Color) var color = Color.white

onready var sprite = $Sprite
onready var flip_sound = $FlipSound

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.modulate = color
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
	emit_signal("flip")


