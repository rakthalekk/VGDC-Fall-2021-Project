# This program uses code from the "Make a Laser Beam in Godot in 1 Minute video by GDQuest.
# CC-By 4.0 - GDQuest and contributors - https://www.gdquest.com/
class_name Beam
extends RayCast2D

export var is_casting := true setget set_is_casting

var reflecting = false

onready var line = $"Line2D"
onready var parent = $".."


func _ready():
	set_is_casting(parent.enabled)
	set_physics_process(is_casting)
	line.points[1] = Vector2.ZERO


func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		var collider = get_collider()
		cast_point = to_local(get_collision_point())
		if collider is LaserBase:
			parent.emit_signal("power_on")
		elif collider is Mirror:
			if collider.orientation == "up" && !reflecting:
				if cast_point.x > 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(0, -1), Vector2(0, -1000))
				elif cast_point.x < 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(0, 1), Vector2(0, 1000))
				elif cast_point.y > 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(-1, 0), Vector2(-1000, 0))
				elif cast_point.y < 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(1, 0), Vector2(1000, 0))
				reflecting = true
			elif collider.orientation == "down" && !reflecting:
				if cast_point.x > 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(0, 1), Vector2(0, 1000))
				elif cast_point.x < 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(0, -1), Vector2(0, -1000))
				elif cast_point.y > 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(1, 0), Vector2(1000, 0))
				elif cast_point.y < 0:
					parent.add_beam(parent.to_local(get_collision_point()) + Vector2(-1, 0), Vector2(-1000, 0))
				reflecting = true
		else:
			reflecting = false
	line.points[1] = cast_point
	if parent.debug:
		print(position)
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
	$Tween.interpolate_property(line, "width", 0, 10.0, 0.2)
	$Tween.start()


func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property(line, "width", 10.0, 0, 0.1)
	$Tween.start()


func _on_LaserBase_enable():
	set_is_casting(true)


func _on_Lever_enable():
	set_is_casting(true)


func _on_Lever_disable():
	set_is_casting(false)
