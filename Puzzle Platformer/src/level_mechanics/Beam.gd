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
		
		# If the beam is colliding with a base, call the base's power_on function
		if collider is LaserBase:
			if !collider.powered:
				collider.power_on()
		
		# If the beam is colliding with a generator, call the generator's power_on function
		elif collider is Generator:
			if !collider.charged:
				collider.power_gen()
		
		# If the beam is colliding with a mirror, reflect it accordingly
		elif collider is Mirror:
			var dir = Vector2.ZERO
			
			# Redirects the beam based on what direction it came from
			if collider.orientation == "up" && !reflecting:
				if cast_point.x > 0:
					dir = Vector2(0, -1)
				elif cast_point.x < 0:
					dir = Vector2(0, 1)
				elif cast_point.y > 0:
					dir = Vector2(-1, 0)
				elif cast_point.y < 0:
					dir = Vector2(1, 0)
				reflecting = true
				parent.add_beam(parent.to_local(get_collision_point()) + dir, dir * 1000)
			elif collider.orientation == "down" && !reflecting:
				if cast_point.x > 0:
					dir = Vector2(0, 1)
				elif cast_point.x < 0:
					dir = Vector2(0, -1)
				elif cast_point.y > 0:
					dir = Vector2(1, 0)
				elif cast_point.y < 0:
					dir = Vector2(-1, 0)
				reflecting = true
				parent.add_beam(parent.to_local(get_collision_point()) + dir, dir * 1000)
			
			# Stops reflecting for a frame if the mirror orientation is updated, so
			# that a new beam can be generated
			elif reflecting && collider.update_orientation:
				reflecting = false
				collider.update_orientation = false
		
		elif collider is XMirror:
			var dir1 = Vector2.ZERO
			var dir2 = Vector2.ZERO
			if !reflecting:
				if cast_point.x != 0:
					dir1 = Vector2(0, -1)
					dir2 = Vector2(0, 5)
				elif cast_point.y != 0:
					dir1 = Vector2(-1, 0)
					dir2 = Vector2(1, 0)
				reflecting = true
				print(dir1)
				print(dir2)
				parent.add_beam(parent.to_local(get_collision_point()) + dir1, dir1 * 1000)
				parent.add_beam(parent.to_local(get_collision_point()) + dir2, dir2 * 1000)
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
	$Tween.interpolate_property(line, "width", 0, 5.0, 0.2)
	$Tween.start()


func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property(line, "width", 5.0, 0, 0.1)
	$Tween.start()


func _on_LaserBase_enable():
	set_is_casting(true)


func _on_Lever_enable():
	set_is_casting(true)


func _on_Lever_disable():
	set_is_casting(false)
