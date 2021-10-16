class_name LaserReceiver
extends LaserSensor

signal disable

var counter = 0

func _process(delta):
	if counter > 0:
		counter -= 1
	elif powered:
		powered = false
		emit_signal("disable")
		anim_player.play("empty")

func power_on():
	counter = 30
	if !powered:
		anim_player.play("charging")
