# TileMap for barrier
extends TileMap

# bool value to indicate if the barrier is enabled or disabled
var enabled = false


func update_tilemap(id):
	for tile in get_used_cells():
		set_cellv(tile, id)


# if lever signal is "enabled", calls _ready function again to check
func _on_Lever_enable():
	enabled = false
	update_tilemap(0)


func _on_Lever_disable():
	enabled = true
	update_tilemap(1)


func _on_LaserBase_enable():
	enabled = false
	update_tilemap(0)
	# new function to turn barrier on
	# "0" = fill, "1" = clear
