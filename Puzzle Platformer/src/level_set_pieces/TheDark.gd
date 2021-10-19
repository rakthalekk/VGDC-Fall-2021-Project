extends TileMap


func _ready():
	if Global.shotdark:
		visible = true
	else:
		visible = false
