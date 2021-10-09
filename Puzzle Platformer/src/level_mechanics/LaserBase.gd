class_name LaserBase
extends Area2D

signal enable

func _on_Laser_power_on():
	emit_signal("enable")
