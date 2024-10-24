extends ColorRect

@onready var screen_size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	self.size = screen_size + Vector2(10,10)
	position = Vector2(-5,-5)

