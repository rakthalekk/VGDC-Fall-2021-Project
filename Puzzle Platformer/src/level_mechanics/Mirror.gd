class_name Mirror
extends Area2D

export(String, "up", "down") var orientation = "up"

onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if orientation == "down":
		sprite.scale.y = -1

