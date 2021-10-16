# TileMap for barrier
extends TileMap

# bool value to indicate if the barrier is enabled or disabled
var enabled = false
var gone = false

onready var flip_sound = $FlipSound

func update_tilemap(id):
	flip_sound.play()
	for tile in get_used_cells():
		set_cellv(tile, id)
	update_bitmask_region()


# if lever signal is "enabled", calls _ready function again to check
func _on_Lever_enable():
	enabled = false
	update_tilemap(0)


func _on_Lever_disable():
	enabled = true
	update_tilemap(1)


func _on_LaserSensor_enable():
	enabled = false
	gone = true
	update_tilemap(0)


func _on_LaserReceiver_enable():
	if !gone:
		enabled = false
		update_tilemap(0)


func _on_LaserReceiver_disable():
	if !gone:
		enabled = true
		update_tilemap(1)
