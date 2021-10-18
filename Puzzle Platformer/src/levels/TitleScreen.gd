extends Node2D


onready var titlescrn = $TitleScreenButtons
onready var lvlselect = $LevelSelectButtons

func _ready():
	$AnimationPlayer.play("title")


func _on_Button_pressed():
	Global.go_next_stage()


func _on_LevelSelect_pressed():
	titlescrn.visible = false
	lvlselect.visible = true


func _on_Settings_pressed():
	print("sorry no settings yet")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	lvlselect.visible = false
	titlescrn.visible = true


func _on_Lvl1_pressed():
	Global.go_next_stage(1)


func _on_Lvl2_pressed():
	Global.go_next_stage(2)


func _on_Lvl3_pressed():
	Global.go_next_stage(3)
