extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Animate_arrow()
	pass # Replace with function body.
	
func Animate_arrow():
	var original_position : Vector2 = position
	var arrow_tween = get_tree().create_tween().set_loops()
	arrow_tween.bind_node(self)
	arrow_tween.tween_property(self, "position:y", original_position.y + 10, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	arrow_tween.tween_property(self, "position:y", original_position.y, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	pass
