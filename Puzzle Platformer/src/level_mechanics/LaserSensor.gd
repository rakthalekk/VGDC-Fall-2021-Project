class_name LaserSensor
extends Area2D

signal enable

export(String, "up", "down", "left", "right") var orientation = "up"
export(bool) var ignore_sound_on_startup = false

var powered = false

onready var hcollider = $HCollider
onready var vcollider = $VCollider
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var charge_sound = $ChargeSound

func _ready():
	anim_player.play("empty")
	if orientation == "right":
		sprite.rotation_degrees = 90
		vcollider.position = Vector2(-4.3, 0)
		vcollider.disabled = false
	elif orientation == "down":
		sprite.rotation_degrees = 180
		hcollider.position = Vector2(0, -4.3)
		hcollider.disabled = false
	elif orientation == "left":
		sprite.rotation_degrees = 270
		vcollider.disabled = false
	elif orientation == "up":
		sprite.rotation_degrees = 0
		hcollider.disabled = false


func power_on():
	anim_player.play("charging")


func set_full_anim():
	anim_player.play("full")
	emit_signal("enable")
	powered = true

func play_charge_sound():
	if !ignore_sound_on_startup:
		charge_sound.play()
	else:
		ignore_sound_on_startup = false
