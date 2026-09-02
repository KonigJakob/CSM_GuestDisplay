extends ColorRect

var map_parent

func _ready():
	map_parent = $".."
	get_child(0).button_down.connect(on_button_down)

func on_button_down():
	self.visible = false;
	for t in map_parent.maptiles:
		if t.is_pressed:
			t._on_pressed()
