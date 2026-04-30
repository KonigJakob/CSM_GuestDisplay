extends Label

var pos_tween

# Called when the node enters the scene tree for the first time.
func _ready():
	animate_label()
	pass

func animate_label():
	await get_tree().create_timer(randf_range(5, 10)).timeout
	
	pos_tween = get_tree().create_tween()
	var original_position : float = position.y
	
	pos_tween.tween_property(self, "position:y", original_position - 25, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	pos_tween.tween_property(self, "position:y", original_position, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	pos_tween.tween_callback(animate_label)
