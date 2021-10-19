extends Area2D

onready var generator = $"../Generator"
onready var sprite = $Sprite

func _on_ResetIndicator_body_entered(body):
	if body is Player && !generator.charging:
		sprite.visible = true
