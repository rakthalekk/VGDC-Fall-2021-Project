# This program uses code from the "Make a Laser Beam in Godot in 1 Minute video by GDQuest.
# CC-By 4.0 - GDQuest and contributors - https://www.gdquest.com/
class_name Laser
extends RayCast2D

signal power_on

export var is_casting := true setget set_is_casting
export(bool) var debug = false

var idx = 1

onready var collider = $"Area2D/Collider"


func _ready():
	set_physics_process(is_casting)
	$Line2D.points[1] = Vector2.ZERO


func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		var collider = get_collider()
		cast_point = to_local(get_collision_point())
		if collider is LaserBase:
			emit_signal("power_on")
		elif collider is Mirror:
			if collider.orientation == "up":
				if cast_point.x > 0:
					$Line2D.points[1] = cast_point
					position = get_collision_point() + Vector2(0, -5)
					cast_to = Vector2(0, -1000)
					idx = 2
			else:
				pass
			print("hi")
	
	$Line2D.points[idx] = cast_point
	if debug:
		print(cast_point)


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
	set_is_casting(true)


func _on_Lever_enable():
	set_is_casting(true)


func _on_Lever_disable():
	set_is_casting(false)
