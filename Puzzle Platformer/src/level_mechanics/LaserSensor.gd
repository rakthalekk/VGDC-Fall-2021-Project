class_name LaserBase
extends Area2D

signal enable

export(String, "up", "down", "left", "right") var orientation = "up"

var powered = false

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var charge_sound = $ChargeSound

func _ready():
	anim_player.play("empty")
	if orientation == "right":
		sprite.rotation_degrees = 90
	elif orientation == "down":
		sprite.rotation_degrees = 180
	elif orientation == "left":
		sprite.rotation_degrees = 270

func power_on():
	anim_player.play("charging")


func set_full_anim():
	anim_player.play("full")
	emit_signal("enable")
	powered = true

func play_charge_sound():
	charge_sound.play()
