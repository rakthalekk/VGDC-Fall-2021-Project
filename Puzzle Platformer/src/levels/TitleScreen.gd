extends Node2D


onready var titlescrn = $TitleScreenButtons
onready var lvlselect = $LevelSelectButtons
onready var settings = $Settings

func _ready():
	$AnimationPlayer.play("title")


func _on_Button_pressed():
	Global.go_next_stage()


func _on_LevelSelect_pressed():
	titlescrn.visible = false
	lvlselect.visible = true


func _on_Settings_pressed():
	titlescrn.visible = false
	settings.visible = true


func _on_Quit_pressed():
	get_tree().quit()


func _on_BackLvl_pressed():
	lvlselect.visible = false
	titlescrn.visible = true


func _on_Lvl1_pressed():
	Global.go_next_stage(1)


func _on_Lvl2_pressed():
	Global.go_next_stage(2)


func _on_Lvl3_pressed():
	Global.go_next_stage(3)


func _on_Lvl4_pressed():
	Global.go_next_stage(4)


func _on_Lvl5_pressed():
	Global.go_next_stage(5)


func _on_Lvl6_pressed():
	Global.go_next_stage(6)


func _on_Lvl7_pressed():
	Global.go_next_stage(7)


func _on_BackSettings_pressed():
	settings.visible = false
	titlescrn.visible = true


func _on_Misfortune_toggled(button_pressed):
	if button_pressed:
		Global.misfortune = true
	else:
		Global.misfortune = false


func _on_Lesser_toggled(button_pressed):
	if button_pressed:
		Global.amogus = true
	else:
		Global.amogus = false


func _on_Shot_toggled(button_pressed):
	if button_pressed:
		Global.shotdark = true
	else:
		Global.shotdark = false

