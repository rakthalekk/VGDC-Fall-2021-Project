extends Node2D


func _ready():
	$AnimationPlayer.play("title")


func _on_Button_pressed():
	Global.go_next_stage()


func _on_LevelSelect_pressed():
	pass # Replace with function body.


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
