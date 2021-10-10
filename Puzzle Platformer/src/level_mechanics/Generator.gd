class_name Generator
extends StaticBody2D

var charging = false
var charged = false

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("empty")


func set_full_anim():
	anim_player.play("full")
	charged = true


func _on_Laser_power_gen():
	if !charged:
		anim_player.play("charging")
		charging = true
