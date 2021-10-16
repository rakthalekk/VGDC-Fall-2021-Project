class_name Mirror
extends Area2D

export(String, "up", "down") var orientation = "up"
export(bool) var enabled = true
#export(Vector2) var move_to = Vector2.ZERO
#export(bool) var moving = false

var update_orientation = false
var speed = Vector2(1, 1)
var origin = Vector2.ZERO
var dest = Vector2.ZERO

onready var sprite = $Sprite
onready var flip_sound = $FlipSound
onready var collider = $CollisionShape2D
onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	update_enabled()
	update_sprite()
	if enabled:
		anim_player.play("enable")
	else:
		anim_player.play("disable")


#func _process(delta):
#	if moving:
#		if position == dest:
#			if dest == origin:
#				dest = origin + move_to
#			else:
#				dest = origin
#			#moving = false
#
#		if position.x < dest.x:
#			position.x += speed.x
#		elif position.x > dest.x:
#			position.x -= speed.x
#		if position.y < dest.y:
#			position.y += speed.y
#		elif position.y > dest.y:
#			position.y -= speed.y


func update_sprite():
	if orientation == "down":
		sprite.scale.y = -1
	else:
		sprite.scale.y = 1


func update_enabled():
	if !enabled:
		collider.disabled = true
	else:
		collider.disabled = false
	#update_orientation = true


func update_or():
	flip_sound.play()
	if orientation == "up":
		orientation = "down"
	else:
		orientation = "up"
	update_orientation = true
	update_sprite()


func _on_LaserSensor_enable():
	update_or()


func _on_Lever_flip():
	update_or()


func _on_Lever_flip_2():
	update_orientation = true
	if enabled:
		enabled = false
		anim_player.play("disable")
	else:
		enabled = true
		anim_player.play("enable")
