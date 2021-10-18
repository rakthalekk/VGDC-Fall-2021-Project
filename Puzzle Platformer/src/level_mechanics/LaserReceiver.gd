class_name LaserReceiver
extends LaserSensor

signal disable

var counter = 0

onready var timer = $Timer

func power_on():
	timer.start()
	if !powered:
		anim_player.play("charging")


func _on_Timer_timeout():
	if powered:
		powered = false
		emit_signal("disable")
		anim_player.play("empty")
