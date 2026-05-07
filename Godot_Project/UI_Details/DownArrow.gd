extends TextureRect

var arrow_tween
var spin_tween


# Called when the node enters the scene tree for the first time.
func _ready():
	Animate_arrow_downwards()
	Spin_arrow()
	
func Animate_arrow_downwards():
	var original_position : Vector2 = position
	if arrow_tween:
		arrow_tween.kill()
	arrow_tween = get_tree().create_tween().set_loops()
	arrow_tween.tween_property(self, "position:y", original_position.y + 10, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	arrow_tween.tween_property(self, "position:y", original_position.y, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	arrow_tween.bind_node(self)
	
func Spin_arrow():
	await get_tree().create_timer(randf_range(5, 10)).timeout
	if spin_tween:
		spin_tween.kill()
	spin_tween = get_tree().create_tween().set_loops(1)
	spin_tween.tween_property(self, "rotation_degrees", 360.0, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)\
	.as_relative()
	
	spin_tween.tween_callback(Spin_arrow)
	spin_tween.bind_node(self)
