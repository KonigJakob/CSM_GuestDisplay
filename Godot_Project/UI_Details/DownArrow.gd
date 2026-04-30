extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Animate_arrow()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Animate_arrow():
	var original_position : Vector2 = position
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(self, "position:y", original_position.y + 10, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_position.y, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	pass
