# This program uses code from the "Make a Laser Beam in Godot in 1 Minute video by GDQuest.
# CC-By 4.0 - GDQuest and contributors - https://www.gdquest.com/
class_name Laser
extends RayCast2D

signal power_on

export var is_casting := true setget set_is_casting

onready var collider = $"Area2D/Collider"


func _ready():
	set_physics_process(is_casting)
	$Line2D.points[1] = Vector2.ZERO


func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		if get_collider() is LaserBase:
			emit_signal("power_on")
	
	$Line2D.points[1] = cast_point


func set_is_casting(cast: bool):
	is_casting = cast
	
	if is_casting:
		appear()
	else:
		disappear()
	set_physics_process(is_casting)


func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
	$Tween.start()


func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
	$Tween.start()


func _on_LaserBase_enable():
	is_casting = true
	set_physics_process(is_casting)
