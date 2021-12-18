# This program uses code from the "Make a Laser Beam in Godot in 1 Minute video by GDQuest.
# CC-By 4.0 - GDQuest and contributors - https://www.gdquest.com/
class_name Beam
extends RayCast2D

export var is_casting := true setget set_is_casting

var reflecting = false
var sub_beams = []

onready var line = $"Line2D"
onready var parent = $".."


func _ready():
	set_is_casting(parent.enabled)
	set_physics_process(is_casting)
	line.points[1] = Vector2.ZERO
	if parent.deadly:
		line.default_color = Color.red


func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	if is_colliding():
		var collider = get_collider()
		cast_point = to_local(get_collision_point())
		
		# If the beam is colliding with a base, call the base's power_on function
		if collider is LaserSensor:
			if !collider.powered || collider is LaserReceiver:
				collider.power_on()
		
		# If the beam is colliding with a generator, call the generator's power_on function
		elif collider is Generator:
			collider.power_gen()
		
		# If the beam is colliding with the player
		elif collider is Player:
			if parent.deadly:
				collider.kill()
			
		# If the beam is colliding with a mirror, reflect it accordingly
		if collider is Mirror:
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
				parent.add_beam(self, parent.to_local(get_collision_point()) + dir, dir * 1000)
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
				parent.add_beam(self, parent.to_local(get_collision_point()) + dir, dir * 1000)
			
			# Stops reflecting for a frame if the mirror orientation is updated, so
			# that a new beam can be generated
			if reflecting && collider.update_orientation:
				reflecting = false

				# Waits 0.01 seconds in case mirror is reflecting multiple lasers
				yield(get_tree().create_timer(.01), "timeout")
				collider.update_orientation = false
		
		elif collider is XMirror:
			var dir1 = Vector2.ZERO
			var dir2 = Vector2.ZERO
			if !reflecting:
				if cast_point.x != 0:
					dir1 = Vector2(0, -2)
					dir2 = Vector2(0, 2)
				elif cast_point.y != 0:
					dir1 = Vector2(-2, 0)
					dir2 = Vector2(2, 0)
				reflecting = true
				var col_pos = parent.to_local(get_collision_point())
				parent.add_beam(self, col_pos + dir1, dir1 * 1000)
				parent.add_beam(self, col_pos + dir2, dir2 * 1000)
		else:
			reflecting = false
	line.points[1] = cast_point
	
	if !reflecting:
		delete_sub_beams()


func delete_sub_beams():
	while sub_beams.size() > 0:
		sub_beams[0].reflecting = true
		sub_beams[0].delete_sub_beams()
		sub_beams[0].queue_free()
		sub_beams.remove(0)


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


func enable():
	set_is_casting(true)


func disable():
	set_is_casting(false)

