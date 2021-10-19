# TileMap for barrier
extends TileMap

export(bool) var ignore_sound_on_startup = false

# bool value to indicate if the barrier is enabled or disabled
var enabled = false
var locked = false

onready var flip_sound = $FlipSound


func _ready():
	for tile in get_used_cells():
		if get_cellv(tile) == 0:
			enabled = false
		else:
			enabled = true
		break


# Sound parameter used in case multiple barriers are activated once
func update_tilemap(id, sound = true):
	play_sound(sound)
	for tile in get_used_cells():
		set_cellv(tile, id)
	update_bitmask_region()


func play_sound(sound):
	if ignore_sound_on_startup:
		ignore_sound_on_startup = false
	elif sound:
		flip_sound.play()


func _on_LaserSensor_enable(sound = true):
	enabled = false
	locked = true
	update_tilemap(0, sound)


func _on_LaserReceiver_enable(sound = true):
	if !locked:
		enabled = false
		update_tilemap(0, sound)


func _on_LaserReceiver_disable(sound = true):
	if !locked:
		enabled = true
		update_tilemap(1, sound)


func _on_Lever_flip(sound = true):
	if !enabled:
		enabled = true
		update_tilemap(1, sound)
	else:
		enabled = false
		update_tilemap(0, sound)


func _on_LaserSensor_disable(sound = true):
	enabled = true
	locked = true
	update_tilemap(1, sound)
