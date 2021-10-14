class_name Generator
extends StaticBody2D

var charging = false
var charged = false

onready var anim_player = $AnimationPlayer
onready var charge_sound = $ChargeSound

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("empty")


func set_full_anim():
	anim_player.play("full")
	charged = true


func power_gen():
	anim_player.play("charging")
	charging = true

func play_charge_sound():
	charge_sound.play()
