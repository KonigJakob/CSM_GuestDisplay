extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(get_viewport().size.x - size.x - 35, 35)

