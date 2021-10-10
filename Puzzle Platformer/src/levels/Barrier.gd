# TileMap for barrier
extends TileMap

# bool value to indicate if the barrier is enabled or disabled
var enabled = false

signal barrier

# Called when the node enters the scene tree for the first time.
# if value is enabled, barrier cells are cleared
func _ready():
	if enabled:
		clear()

# if lever signal is "enabled", calls _ready function again to check
func _on_Lever_enable():
	enabled = true
	_ready()
	
# NOTE: to add new object to deactivate barrier, instead of lever
