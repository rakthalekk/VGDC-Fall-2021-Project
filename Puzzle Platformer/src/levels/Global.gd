extends Node

var current_scene = 0
var misfortune = false
var amogus = false
var shotdark = false

func go_next_stage(scene = current_scene + 1):
	if (scene > 6):
		get_tree().change_scene("res://src/levels/Win.tscn")
		return
	current_scene = scene
	get_tree().change_scene("res://src/levels/Level"+str(current_scene)+".tscn")


func return_to_title():
	get_tree().change_scene("res://src/levels/TitleScreen.tscn")
	current_scene = 0
	misfortune = false
	amogus = false
	shotdark = false
