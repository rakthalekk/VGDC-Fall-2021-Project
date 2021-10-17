# TileMap for barrier
extends TileMap

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


func update_tilemap(id):
	flip_sound.play()
	for tile in get_used_cells():
		set_cellv(tile, id)
	update_bitmask_region()


func _on_LaserSensor_enable():
	enabled = false
	locked = true
	update_tilemap(0)


func _on_LaserReceiver_enable():
	if !locked:
		enabled = false
		update_tilemap(0)


func _on_LaserReceiver_disable():
	if !locked:
		enabled = true
		update_tilemap(1)


func _on_Lever_flip():
	if !enabled:
		enabled = true
		update_tilemap(1)
	else:
		enabled = false
		update_tilemap(0)


func _on_LaserSensor_disable():
	enabled = true
	locked = true
	update_tilemap(1)
