class_name Generator
extends StaticBody2D

var charging = false
var charged = false
var counter = 0

onready var anim_player = $AnimationPlayer
onready var charge_sound = $ChargeSound

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("empty")


func _process(delta):
	if counter > 0:
		counter -= 1
	elif charging:
		charging = false
		charged = false
		anim_player.play("empty")


func set_full_anim():
	anim_player.play("full")
	charged = true
	$LevelSwitch.start()


func power_gen():
	counter = 30
	if !charging && !charged:
		anim_player.play("charging")
		charging = true


func play_charge_sound():
	charge_sound.play()


func _on_LevelSwitch_timeout():
	if charged:
		Global.go_next_stage()
