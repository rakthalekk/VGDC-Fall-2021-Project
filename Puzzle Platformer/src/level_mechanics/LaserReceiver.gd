class_name LaserReceiver
extends LaserSensor

signal disable

var counter = 0
var dis = false

onready var timer = $Timer

func power_on():
	timer.start()
	if !powered:
		anim_player.play("charging")


func set_empty_anim():
	anim_player.play("empty")
	if dis:
		emit_signal("disable")
		dis = false


func _on_Timer_timeout():
	anim_player.play("emptying")
	if powered:
		dis = true
	powered = false
